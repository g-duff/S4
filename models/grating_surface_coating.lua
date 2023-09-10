PERIOD = 560
FILL_FACTOR = 0.75
GRATING_THICKNESS = 150
ANALYTE_THICKNESS = 20

S = S4.NewSimulation()
S:SetLattice({PERIOD, 0}, {0, 0}) -- 1D lattice
S:SetNumG(50) -- resolve thin analyte with higher harmonics

-- Material definition
S:AddMaterial('Analyte', {1.60*1.60, 0}) -- real and imag permittivity
S:AddMaterial('Silica', {1.46*1.46, 0})
S:AddMaterial('SiliconNitride', {2.00*2.00, 0}) 
S:AddMaterial('Water', {1.3*1.3, 0})

-- Structure definition
S:AddLayer('Substrate', 0, 'Silica')

-- Set analyte background then overlay silicon nitride feature
S:AddLayer('Grating', GRATING_THICKNESS, 'Water')
S:SetLayerPatternRectangle(
	'Grating',
	'Analyte',
	{0, 0},
	0,
	{PERIOD*FILL_FACTOR/2 + ANALYTE_THICKNESS, 0}
)
S:SetLayerPatternRectangle(
	'Grating',
	'SiliconNitride',
	{0, 0},
	0,
	{PERIOD*FILL_FACTOR/2, 0}
)

S:AddLayer('GratingTopCoating', ANALYTE_THICKNESS, 'Water')
S:SetLayerPatternRectangle(
	'GratingTopCoating',
	'Analyte',
	{0, 0},
	0,
	{PERIOD*FILL_FACTOR/2 + ANALYTE_THICKNESS, 0}
)

S:AddLayer('Superstrate', 0, 'Water')

S:SetExcitationPlanewave(
	{0, 0},	-- incidence angles (spherical coordinates: phi in [0,180], theta in [0,360])
	{1, 0},	-- s-polarization amplitude and phase (in degrees)
	{0, 0}	-- p-polarization amplitude and phase
)

-- Field plot
for z = -50, GRATING_THICKNESS+ANALYTE_THICKNESS+50, 1 do
	for x = -PERIOD/2, PERIOD/2, 1 do
		eps_r, eps_i = S:GetEpsilon({x, 0, z})
		io.write(string.format("%.2f\t", eps_r))
	end
	io.write("\n")
end

-- Wavelength spectrum
for wavelength=780,880,3 do
	frequency = 1/wavelength
	S:SetFrequency(frequency, 0)
	incident, reflection = S:GetPowerFlux('Substrate', 0)
	transmission = S:GetPowerFlux('Superstrate', 0)
	print(string.format("%.2f, %.2f, %.2f, %.2f", wavelength, incident, transmission, -reflection))
end
