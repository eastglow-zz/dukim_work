
[Mesh]
  type = GeneratedMesh
  nx = 100
  ny = 100
  dim = 2
  xmax = 6.283184
  ymax = 6.283184
[]

[Variables]
  [./aeta]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./dx_aeta]
    order = FIRST
    family = MONOMIAL
  [../]
  [./dy_aeta]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[ICs]
  [./aeta_IC]
    type = FunctionIC
    variable = aeta
    function = 'sin(x)+sin(y)'
  [../]
[]

[BCs]
[]

[AuxKernels]
  [./calc_dx_aeta]
    type = VariableGradientComponent
    component = x
    variable = dx_aeta
    gradient_variable = aeta
    execute_on = TIMESTEP_BEGIN
  [../]
  [./calc_dy_aeta]
    type = VariableGradientComponent
    component = y
    variable = dy_aeta
    gradient_variable = aeta
    execute_on = TIMESTEP_BEGIN
  [../]
[]

[Kernels]
  [./TimeDerivative]
    type = TimeDerivative
    variable = aeta
  [../]
[]

[Materials]
  [./f_first]
    type = DerivativeParsedMaterial
    args = 'aeta dx_aeta dy_aeta'
    constant_names =       'A B C'
    constant_expressions = '1 2 3'
    f_name = f_first
    function = 'A*aeta + B*dx_aeta + C*dy_aeta'
    derivative_order = 1
    outputs = exodus
  [../]

  [./f_second]
    type = DerivativeParsedMaterial
    args = 'aeta dx_aeta dy_aeta'
    constant_names =       'A11 B11 B12 B22'
    constant_expressions = '10  11  12  22'
    f_name = f_second
    function = '0.5*A11*aeta^2 + 0.5*B11*dx_aeta^2 + B12*dx_aeta*dy_aeta + 0.5*B22*dy_aeta^2'
    derivative_order = 2
    outputs = exodus
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  scheme = explicit-euler
  steady_state_detection = true
  steady_state_tolerance = 1e-08

  l_max_its = 20
  l_tol = 1e-7
  nl_max_its = 20
  nl_rel_tol = 1e-7
  line_search = none

  dt = 0.1
[]

[Outputs]
  exodus = true
[]
