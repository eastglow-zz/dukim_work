

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 1
  ymax = 1
[]

[Variables]
  [./p]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./px]
    order = FIRST
    family = MONOMIAL
  [../]
  [./py]
    order = FIRST
    family = MONOMIAL
  [../]
  #[./pz]
  #  order = FIRST
  #  family = MONOMIAL
  #[../]
[]

[ICs]
  [./u_circle_IC]
    type = SmoothCircleIC
    variable = p
    x1 = 0.5
    y1 = 0.5
    radius = 0.02
    int_width = 0.06
    invalue = 1
    outvalue = 0
  [../]
[]

[BCs]
[]

[AuxKernels]
  [./calc_px]
    type = VariableGradientComponent
    variable = px
    gradient_variable = p
    component = x
    execute_on = TIMESTEP_BEGIN
  [../]
  [./calc_py]
    type = VariableGradientComponent
    variable = py
    gradient_variable = p
    component = y
    execute_on = TIMESTEP_BEGIN
  [../]
  #[./calc_pz]
  #  type = VariableGradientComponent
  #  variable = pz
  #  gradient_variable = p
  #  component = z
  #  execute_on = TIMESTEP_BEGIN
  #[../]
[]

[Kernels]
  [./TimeDerivative]
    type = TimeDerivative
    variable = p
    #tau_name = tau_op
    #Coupled_variables = 'px py'
  [../]
  #[./AnisotropicDiffusion]
  #  type = myDPMtraining
  #  variable = p
  #  mob_name = L
  #  kappa_name = kappa_op
  #  coupled_variables = 'px py'
  #[../]
  [./AnisotropicDiffusion]
    type = myDPMtraining2
    variable = p
    mob_name = L
    kappa_name = kappa_op
    grad_aeta_x = px
    grad_aeta_y = py
  [../]
[]

[Materials]
  [./Anisotropy_strength]
    type = GenericConstantMaterial
    prop_names = eps0
    prop_values = 0.05
  [../]
  [./kappa]
    type = DerivativeParsedMaterial
    f_name = kappa_op
    args = 'px py'
    constant_names =       'k0'
    constant_expressions = '1.0'
    material_property_names = 'eps0'
    function = 'if(px^2 + py^2 > 100, k0 * (1 + eps0 * (px^4 + py^4)/(px^2 + py^2))^2,0)'
    #function = 'k0'
    derivative_order = 2
    outputs = exodus
  [../]
  [./L]
    type = GenericConstantMaterial
    prop_names = L
    prop_values = 1.0
  [../]
  [./tau]
    type = DerivativeParsedMaterial
    f_name = tau_op
    args = 'px py'
    constant_names =       'tau0'
    constant_expressions = '1'
    material_property_names = 'eps0'
    function = 'if(px^2 + py^2 > 100, tau0 * (1 + eps0 * (px^4 + py^4)/(px^2 + py^2))^2,0)'
    #function = 'k0'
    derivative_order = 2
    outputs = exodus
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  #solve_type = NEWTON
  scheme = bdf2

  #steady_state_detection = true
  #steady_state_tolerance = 1e-08

  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm      lu          ' #asm: Additive Schwartz method, lu: LU factorization

  l_max_its = 50
  l_tol = 1e-20
  nl_max_its = 20
  nl_rel_tol = 1e-11
  line_search = none

  dt = 1e-9
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-9
    optimal_iterations = 20
    iteration_window = 5
  [../]
[]

[Outputs]
  exodus = true
  print_perf_log = true
[]
