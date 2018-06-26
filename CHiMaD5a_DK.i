# CHiMaD benchmark problem #5 Stokes flow with MOOSE Navier-Stokes Modules
# Activation of navier_stokes module is required during compiling the code.
# Incompressible fluid flow with gravity in 2D

# 5a; without obstacle

[Mesh]
  type = FileMesh
  file = CHiMaD5a_mesh.msh
[]

mu=1
rho=100

[GlobalParams]
  #Variable coupling and naiming
  u = vel_x
  v = vel_y
  p = p

  #Stabilization Parameters
  supg = true
  pspg = true
  alpha = 1e0

  #Problem coefficients
  gravity = '0 -0.001 0'

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
  [./p]
    order = FIRST
    family = LAGRANGE
  [../]
[]

#[AuxVariables]
#  [./Check_Bernoulli]
#    order = CONSTANT
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
  #[./x_gravity]
  #  type = NSGravityForce
  #  variable = vel_x
  #[../]

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
  #[./y_gravity]
  #  type = NSGravityForce
  #  variable = vel_y
  #  acceleration = gravity
  #[../]
[]

[Functions]
  [./Inlet_vel]
    type = ParsedFunction
    value = '-0.001*(y-3)^2+0.009'
  [../]
[]

[BCs]
  [./vel_x_inlet]
    type = FunctionDirichletBC
    variable = vel_x
    function = Inlet_vel
    value = 0.0
    boundary = inlet
  [../]
  [./vel_y_inlet]
    type = DirichletBC
    variable = vel_y
    value = 0.0
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
  [./Pressure]
    type = DirichletBC
    variable = p
    value = 0.0
    boundary = pressure_confine
  [../]

  #BC for outlet; natueal BC
  #BC for pressure; natural BC
[]

[Materials]
  [./Constants]
    type = GenericConstantMaterial
    prop_names =  'rho mu'
    prop_values = '100 1'
  [../]
[]

[Preconditioning]
  [./SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
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
