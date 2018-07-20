
# Units:
#  Length: mm
#  Time: ms
#  Mass: g

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 8
  ymax = 8
  #type = FileMesh
  #file = notch.msh
[]

[GlobalParams]
  #Variable coupling and naiming
  u = v_x
  v = v_y
  #w = v_z
  p = p

  #Stabilization Parameters
  supg = true
  #supg = false
  pspg = true
  alpha = 1e0

  #Problem coefficients
  #gravity = '0 0 0'
  gravity = '0 -9.81e-3 0'

  #Weak form customization
  convective_term = true
  #convective_term = false
  integrate_p_by_parts = true
  transient_term = true
  laplace = true
[]

[Variables]
  [./c]  # phase-field
    order = FIRST
    family = LAGRANGE
  [../]

  [./w]  # dF/dc
    order = FIRST
    family = LAGRANGE
  [../]

  [./v_x] # x-velocity
    order = FIRST
    family = LAGRANGE
  [../]
  [./v_y] # y-velocity
    order = FIRST
    family = LAGRANGE
  [../]
  [./p] # pressure
    order = FIRST
    family = LAGRANGE
  [../]

[]

[AuxVariables]
  [./gradw_x]  #for the interfacial force tern
    order = FIRST
    family = MONOMIAL
  [../]

  [./gradw_y]  #for the interfacial force tern
    order = FIRST
    family = MONOMIAL
  [../]

  [./Fs_x]  # interfacial force, x-component
    order = FIRST
    family = MONOMIAL
  [../]

  [./Fs_y]  # interfacial force, y-component
    order = FIRST
    family = MONOMIAL
  [../]

  # for the coupled advection term in w-kernel of C-H eqn.
  [./gradc_x]
    order = FIRST
    family = MONOMIAL
  [../]
  [./gradc_y]
    order = FIRST
    family = MONOMIAL
  [../]
  [./time]
  [../]
[]

[ICs]
  [./cIC]
    type = SmoothCircleIC
    variable = c
    x1 = 4
    y1 = 2
    radius = 1.0
    int_width = 0.32   #6-element size
    invalue = 1.0
    outvalue = 0.0
  [../]

  [./vel_x_IC]
    type = ConstantIC
    variable = v_x
    value = 0.0
  [../]

  [./vel_y_IC]
    type = ConstantIC
    variable = v_y
    value = 0.0
  [../]
[]

[AuxKernels]
  [./time]
    type = FunctionAux
    variable = time
    function = t
  [../]
  [./calc_gradw_x]
    type = VariableGradientComponent
    variable = gradw_x
    gradient_variable = w
    component = x
    execute_on = LINEAR
  [../]

  [./calc_gradw_y]
    type = VariableGradientComponent
    variable = gradw_y
    gradient_variable = w
    component = y
    execute_on = LINEAR
  [../]

  [./calc_Fs_x]
    type = ParsedAux
    variable = Fs_x
    args = 'c gradw_x time'
    function = 'if((c-0.01)*(0.99-c) < 0, 0, if(time < 0, 0 , -c*gradw_x))'
    execute_on = LINEAR
  [../]

  [./calc_Fs_y]
    type = ParsedAux
    variable = Fs_y
    args = 'c gradw_y time'
    function = 'if((c-0.01)*(0.99-c) < 0, 0, if(time < 0, 0 , -c*gradw_y))'
    execute_on = LINEAR
  [../]

  [./calc_gradc_x]
    type = VariableGradientComponent
    variable = gradc_x
    gradient_variable = c
    component = x
    execute_on = LINEAR
  [../]

  [./calc_gradc_y]
    type = VariableGradientComponent
    variable = gradc_y
    gradient_variable = c
    component = y
    execute_on = LINEAR
  [../]
[]

[Kernels]
  [./calc_c]
    type = SplitCHParsed
    variable = c
    f_name = fbulk
    kappa_name = kappa_c
    w = w
  [../]

  [./advection_c]
    type = CoupledVarAdvectionConserved
    variable = w
    vel_x = v_x
    vel_y = v_y
    coupled_var = c
  [../]

  [./calc_dFdc]
    type = SplitCHWRes
    variable = w
    mob_name = M_c
  [../]

  [./TimeDerivative_c]
    type = CoupledTimeDerivative
    variable = w
    v = c
  [../]

  [./calc_pressure]
    type = INSMass
    variable = p
    mu_name = mu
    rho_name = rho
  [../]

  [./x_momentum]
    type = INSMomentumLaplaceForm
    variable = v_x
    component = 0
    mu_name = mu
    rho_name = rho
  [../]
  [./y_momentum]
    type = INSMomentumLaplaceForm
    variable = v_y
    component = 1
    mu_name = mu
    rho_name = rho
  [../]

  [./TimeDerivative_vx]
    type = INSMomentumTimeDerivative
    variable = v_x
    rho_name = rho
  [../]
  [./TimeDerivative_vy]
    type = INSMomentumTimeDerivative
    variable = v_y
    rho_name = rho
  [../]

  [./Interfacial_force_x]
    type = CoupledForce
    variable = v_x
    v = Fs_x  #provided by ParsedAux kernel
    coef = 1
  [../]

  [./Interfacial_force_y]
    type = CoupledForce
    variable = v_y
    v = Fs_y  #provided by ParsedAux kernel
    coef = 1
  [../]
  #[./Body_force_test_x]
  #  type = BodyForce
  #  variable = v_x
  #  value = 0
  #[../]

  #[./Body_force_test_y]
  #  type = BodyForce
  #  variable = v_y
  #  value = -9.81e-3
  #[../]
[]

[BCs]
  #[./Periodic]
  #  [./c_x_periodic]
  #    variable = c
  #    auto_direction = 'x'
  #  [../]
  #[../]
  #[./zero_flux_BC]
  #  type = NeumannBC
  #  variable = c
  #  boundary = all
  #  value = 0
  #[../]
  #[./zero_c]
  #  type = DirichletBC
  #  variable = c
  #  boundary = 'left top right'
  #  value = 0
  #[../]
  #Do nothing means no-flux boundary condition
  #[./v_x_inlet]
  #  type = DirichletBC
  #  variable = v_x
  #  value = 0.01
  #  boundary = Inlet
  #[../]
  #[./v_y_inlet]
  #  type = DirichletBC
  #  variable = v_y
  #  value = 0.0
  #  boundary = Inlet
  #[../]
  #[./v_x_outlet]
  #  type = DirichletBC
  #  variable = v_x
  #  value = 0.01
  #  boundary = Outlet
  #[../]
  #[./v_y_outlet]
  #  type = DirichletBC
  #  variable = v_y
  #  value = 0.0
  #  boundary = Outlet
  #[../]
  #[./v_x_wall]
  #  type = DirichletBC
  #  variable = v_x
  #  value = 0.0
  #  boundary = Wall
  #[../]
  #[./v_y_wall]
  #  type = DirichletBC
  #  variable = v_y
  #  value = 0.0
  #  boundary = Wall
  #[../]
  [./v_x_wall]
    type = DirichletBC
    boundary = 'bottom'
    #boundary = 'bottom left right'
    variable = v_x
    value = 0
  [../]
  [./v_y_wall]
    type = DirichletBC
    boundary = 'bottom'
    #boundary = 'bottom left right'
    variable = v_y
    value = 0
  [../]
  #[./v_x_inlet]
  #  type = DirichletBC
  #  boundary = 'left'
  #  variable = v_x
  #  value = 100.0
  #[../]
  #[./v_y_inlet]
  #  type = DirichletBC
  #  boundary = 'left'
  #  variable = v_y
  #  value = 0.0
  #[../]
[]

[Materials]
  [./mat]
    type = GenericConstantMaterial
    prop_names  = 'M_c0 kappa_c'
    #prop_values = '0.1  1.7486e-2'
    prop_values = '200  3.49725e-5'
  [../]
  [./Mobility]
    type = ParsedMaterial
    f_name = M_c
    material_property_names = 'M_c0'
    args = 'c'
    #function = 'M_c0*16*c^2*(1-c)^2'
    function = 'M_c0'
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = 'c'
    constant_names = 'dbe'
    #constant_expressions = '5.2639'
    constant_expressions = '2.63196e-3'
    function = 'dbe*(c)^2*(1-c)^2'
    enable_jit = true
    #outputs = exodus
  [../]

  [./dynamic_viscosity]
    type = DerivativeParsedMaterial
    f_name = mu
    args = 'c'
    constant_names =       'mu_L   mu_V'
    #constant_expressions = '1.002e-6  0.018e-6'
    constant_expressions = '1.002e3  0.018e-6'
    #constant_expressions = '1.002e-6  1.002e-7'
    #constant_expressions = '8.9e-1 8.9e-1'
    function = 'h:=c^3*(10-15*c+6*c^2);if(c*(1-c)>=0,mu_L*h+mu_V*(1-h), if(c > 1, mu_L, mu_V))'
    #type = GenericConstantMaterial
    #prop_names = 'mu'
    #prop_values = '8.9e-4'
    #outputs = exodus
  [../]

  [./massdensity]
    type = DerivativeParsedMaterial
    f_name = rho
    args = 'c'
    constant_names =       'rho_L rho_V'
    constant_expressions = '1e-3  1.1839e-6'
    #constant_expressions = '1e-3  0.8e-3'
    function = 'h:=c^3*(10-15*c+6*c^2);if(c*(1-c)>=0, rho_L*h+rho_V*(1-h), if(c > 1, rho_L, rho_V))'
    #type = GenericConstantMaterial
    #prop_names = 'rho'
    #prop_values = '1000'
    #outputs = exodus
  [../]

  [./Reynolds_number]
    type = ParsedMaterial
    f_name = ReNum
    args = 'c v_x v_y'
    material_property_names = 'rho mu'
    constant_names = 'charleng'
    constant_expressions = '8'
    function = 'rho*(v_x^2+v_y^2)^0.5*charleng/mu'
    outputs = exodus
  [../]
[]

[Postprocessors]
  [./top]
    #type = SideIntegralVariablePostprocessor
    type = ElementIntegralVariablePostprocessor
    variable = c
    #boundary = top
  [../]
[]

[Preconditioning]
  [./cw_coupling]
    type = SMP
    full = true
  #  type = FDP
  #  full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  scheme = bdf2

  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm      lu          '
  #petsc_options_iname = '-pc_type -pc_asm_overlap'
  #petsc_options_value = 'asm      1'

  #petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_levels'
  #petsc_options_value = 'bjacobi  ilu          4'

  l_max_its = 50
  l_tol = 1e-5
  nl_max_its = 10
  nl_rel_tol = 1e-08
  #nl_abs_tol = 1e-8

  dt = 0.1
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1
    cutback_factor = 0.5
    growth_factor = 2.0
    optimal_iterations = 20
    iteration_window = 5
  [../]
  end_time = 500.0
  #end_time = 2000.0
  # adaptive mesh to resolve an interface
  #[./Adaptivity]
  #  initial_adaptivity    = 1             # Number of times mesh is adapted to initial condition
  #  refine_fraction       = 0.7           # Fraction of high error that will be refined
  #  coarsen_fraction      = 0.1           # Fraction of low error that will coarsened
  #  max_h_level           = 3             # Max number of refinements used, starting from initial mesh (before uniform refinement)
  #  weight_names          = 'c	 '
  #  weight_values         = '1  '
  #[../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Outputs]
  exodus = true
  #interval = 1000
  print_perf_log = true
  csv = true
[]
