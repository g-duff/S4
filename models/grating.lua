PERIOD = 560
FILL_FACTOR = 0.75

S = S4.NewSimulation()
S:SetLattice({PERIOD, 0}, {0, 0}) -- 1D lattice
S:SetNumG(15)

-- Material definition
S:AddMaterial('Silica', {1.46*1.46, 0}) -- real and imag parts
S:AddMaterial('SiliconNitride', {2*2, 0}) 
S:AddMaterial('Water', {1.3*1.3, 0})

S:AddLayer('Substrate', 0, 'Silica')

S:AddLayer('Grating', 150, 'Water')
S:SetLayerPatternRectangle(
	'Grating',			-- which layer to alter
	'SiliconNitride',		-- material in rectangle
	{0, 0},				-- center
	0,				-- tilt angle (degrees)
	{PERIOD*FILL_FACTOR/2, 0}	-- half-widths
)

S:AddLayer('Superstrate', 0, 'Water')

S:SetExcitationPlanewave(
	{0, 0},	-- incidence angles (spherical coordinates: phi in [0,180], theta in [0,360])
	{1, 0},	-- s-polarization amplitude and phase (in degrees)
	{0, 0}	-- p-polarization amplitude and phase
)

for wavelength=780,880,3 do
	frequency = 1/wavelength
	S:SetFrequency(frequency, 0)
	incident, reflection = S:GetPowerFlux('Substrate', 0)
	transmission = S:GetPowerFlux('Superstrate', 0)
	print(string.format("%.2f, %.2f, %.2f, %.2f", wavelength, incident, transmission, -reflection))
end
