# Simple inlet-flux-driven flow dynamics simulation with MOOSE Navier-Stokes Modules
# Activation of navier_stokes module is required during compiling the code.
# Incompressible fluid flow with gravity in 3D
# To verify Bernoulli's principle; check the auxiliary variable 'Check_Bernoulli'

[Mesh]
  type = FileMesh
  file = test_Bernoulli_rectangle.msh
[]

mu=8.90e-4  #[Pa*s] Viscosity of water @ 298K
rho=1000.0    #[kg/m^3] density of water @ 298K

[GlobalParams]
  #Variable coupling and naiming
  u = vel_x
  v = vel_y
  w = vel_z
  p = p

  #Stabilization Parameters
  supg = true
  pspg = true
  alpha = 1e0

  #Problem coefficients
  gravity = '0 0 0'

  #Weak form customization
  convective_term = true
  integrate_p_by_parts = true
  transient_term = true
  laplace = true
[]
[Variables]
  [./vel_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./vel_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./vel_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./p]
    order = FIRST
    family = LAGRANGE
  [../]
[]

#[AuxVariables]
#  [./Check_Bernoulli]
#    order = FIRST
#    family = SCALAR
#  [../]
#[]

[ICs]
  [./IC_vel_x]
    type = ConstantIC
    variable = vel_x
    value = 0.0
  [../]
  [./IC_vel_y]
    type = ConstantIC
    variable = vel_y
    value = 0.0
  [../]
  [./IC_vel_z]
    type = ConstantIC
    variable = vel_z
    value = 0.0
  [../]
  #[./IC_pressure]
  #  type = ConstantIC
  #  variable = p
  #  value = 0.0
  #[../]
[]

[Kernels]
  #Continuity equations
  [./mass]
    type = INSMass
    variable = p
  [../]

  #Time derivative of vel_x
  [./x_time]
    type = INSMomentumTimeDerivative
    variable = vel_x
  [../]
  [./x_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_x
    component = 0  #May be x:0, y:1, z:2 ?
  [../]

  #Time derivative of vel_y
  [./y_time]
    type = INSMomentumTimeDerivative
    variable = vel_y
  [../]
  [./y_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_y
    component = 1  #May be x:0, y:1, z:2 ?
  [../]

  #Time derivative of vel_z
  [./z_time]
    type = INSMomentumTimeDerivative
    variable = vel_z
  [../]
  [./z_momentum_space]
    type = INSMomentumLaplaceForm
    variable = vel_z
    component = 2  #May be x:0, y:1, z:2 ?
  [../]
[]

[Functions]
  [./Inlet_vel]
    type = ParsedFunction
    value = '0.05*(1-(x-0.1)*(x+0.1))*(1-(y-0.1)*(y+0.1))'
  [../]
[]

[BCs]
  [./vel_x_inlet]
    type = DirichletBC
    variable = vel_x
    value = 0.0
    boundary = inlet
  [../]
  [./vel_y_inlet]
    type = DirichletBC
    variable = vel_y
    value = 0.0
    boundary = inlet
  [../]
  [./vel_z_inlet]
    type = FunctionDirichletBC
    function = Inlet_vel
    variable = vel_z
    boundary = inlet
  [../]

  [./vel_x_wall] #no-slip boundary conditions
    type = DirichletBC
    variable = vel_x
    value =    0.0
    boundary = wall
  [../]
  [./vel_y_wall] #no-slip boundary conditions
    type = DirichletBC
    variable = vel_y
    value =    0.0
    boundary = wall
  [../]
  [./vel_z_wall] #no-slip boundary conditions
    type = DirichletBC
    variable = vel_z
    value =    0.0
    boundary = wall
  [../]

  #BC for outlet
  #[./vel_x_outlet]
  #  type = INSMomentumNoBCBCLaplaceForm
  #  variable = vel_x
  #  boundary = outlet
  #  u = vel_x
  #  v = vel_y
  #  w = vel_z
  #  p = p
  #  component = 0
  #[../]
  #[./vel_y_outlet]
  #  type = INSMomentumNoBCBCLaplaceForm
  #  variable = vel_y
  #  boundary = outlet
  #  u = vel_x
  #  v = vel_y
  #  w = vel_z
  #  p = p
  #  component = 1
  #[../]
  #[./vel_z_outlet]
  #  type = INSMomentumNoBCBCLaplaceForm
  #  variable = vel_z
  #  boundary = outlet
  #  u = vel_x
  #  v = vel_y
  #  w = vel_z
  #  p = p
  #  component = 2
  #[../]
  #BC for pressure; natural BC
[]

[Materials]
  [./Constants]
    type = GenericConstantMaterial
    prop_names =  'rho  mu'
    prop_values = '1000 8.9e-4'
  [../]

  [./dymamic_pressure]
    type = DerivativeParsedMaterial
    f_name = p_dynamic
    constant_names = 'rho0'
    constant_expressions = '1000'
    args = 'vel_x vel_y vel_z'
    function = '0.5*rho0*(vel_x^2+vel_y^2+vel_z^2)'
    outputs = exodus
  [../]
  [./total_pressure]
    type = DerivativeParsedMaterial
    f_name = p_total
    constant_names = 'rho0'
    constant_expressions = '1000'
    args = 'vel_x vel_y vel_z p'
    function = '0.5*rho0*(vel_x^2+vel_y^2+vel_z^2) + p'
    outputs = exodus
  [../]
[]

[Preconditioning]
  [./SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'NEWTON'
  [../]
[]

[Executioner]
  #Time integrator and time stepper customization
  type = Transient
  num_steps = 100
  trans_ss_check = true
  ss_check_tol = 1e-10
  dtmin = 5e-4
  dt = 0.5
  [./TimeStepper]
    dt = 0.5
    type = IterationAdaptiveDT
    cutback_factor = 0.4
    growth_factor = 1.2
    optimal_iterations = 5
  [../]
  #Solver tolerance and iteration limits
  nl_rel_tol  = 1e-8
  nl_abs_tol  = 1e-12
  nl_max_its  = 50
  l_tol       = 1e-6
  l_max_its   = 50
  line_search = 'none'
  # Options passed directly to PETSc
  petsc_options = '-snes_converged_reason -ksp_converged_reason '
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_package ' petsc_options_value = 'lu NONZERO superlu_dist '
[]

[Outputs]
  exodus = true
[]
