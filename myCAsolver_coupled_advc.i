
#
# One particle growth with constant driving force
#

# Sigma, Interfacial energy: 0.3 J/m^2
# Lambda, the half interfaciel thicknes; interfacial width definition: p(0.05) ~ p(0.95)
# corresponding alpha = 2*ln(0.95/0.05) = 5.8889
# Lambda = 3 * dx
# kappa_p = 12 * Sigma * Lambda / alpha = 6 * (2*Lambda) * Sigma / alpha = 1.834e-6
# w, double well height = 3 * Sigma * alpha / (2*Lambda) = 8.833e5

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 150
  ny = 150
  xmax = 150e-6 #[m]
  ymax = 150e-6 #[m]
[]

[Variables]
  [./p] #phase-field variable
    order = FIRST
    family = LAGRANGE
  [../]
  [./mu] #chemical potential variable
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./v_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./v_y]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./p_circleIC]
    type = SmoothCircleIC
    variable = p
    x1 = 75e-6  #[m]
    y1 = 75e-6  #[m]
    radius = 1e-6  #[m]
    int_width = 6e-6  #[m]
    invalue = 1.0
    outvalue = 0.0
  [../]
  [./mu_constantIC]
    type = SmoothCircleIC
    variable = mu
    x1 = 75e-6  #[m]
    y1 = 75e-6  #[m]
    radius = 1e-6  #[m]
    int_width = 6e-6  #[m]
    invalue = 0.0
    outvalue = 0.2e7
    #type = ConstantIC
    #variable = mu
    #value = 0.2e7
  [../]
  [./vel_x_constantIC]
    type = ConstantIC
    variable = v_x
    value = 0.0
  [../]
  [./vel_y_constantIC]
    type = ConstantIC
    variable = v_y
    value = 0.0
  [../]
[]

[BCs]
  #Do nothing means no-flux boundary condition for p and mu
[]

[Kernels]
  #Phase-field
  [./time_derivative_p]
    type = TimeDerivative
    variable = p
  [../]
  [./advection_p]
    type = ConservativeAdvectionVfield
    variable = p
    vel_x = v_x
    vel_y = v_y
  [../]
  [./InterfacialE]
    type = ACInterface
    variable = p
    mob_name = L
    kappa_name = kappa_p
  [../]
  [./localFE]
    type = AllenCahn
    variable = p
    f_name = f_doublewell
    mob_name = L
  [../]
  #[./DrivingForce]
  #  type = CoupledAllenCahn
  #  variable = p
  #  v = mu
  #  f_name = coupled_drivF
  #  mob_name = L
  #[../]
  [./DrivingForce]
    type = ACSwitching
    variable = p
    Fj_names = 'gpot_a gpot_b'
    hj_names = 'ha     hb'
    args = 'p mu'
    mob_name = L
  [../]

  #Chemical potential field
  [./time_derivative_mu]
    type = TimeDerivative
    variable = mu
  [../]
  [./advection_mu]
    type = ConservativeAdvectionVfield
    variable = mu
    vel_x = v_x
    vel_y = v_y
  [../]
  [./div_grad_mu]
    type = ACInterface
    variable = mu
    mob_name = k
    #kappa_name = M0
    kappa_name = Mob
  [../]
  [./Partition_term]
    type = CoupledSwitchingTimeDerivative
    variable = mu
    v = p
    Fj_names = 'Cma_dha Cmb_dhb'
    hj_names = 'ha      hb'
    args =     'p'
  [../]
[]

[Materials]
  [./f_doublewell]
    type = DerivativeParsedMaterial
    f_name = f_doublewell
    args = 'p'
    material_property_names = 'w'
    function = 'w*p^2*(1-p)^2'
    derivative_order = 2
    outputs = exodus
  [../]
  #[./f_drivingforce]
  #  type = DerivativeParsedMaterial
  #  f_name = coupled_drivF
  #  args = 'p mu'
  #  material_property_names = 'ha hb Ba Bb Cma Cmb'
  #  function = 'ha*(Ba-mu*Cma)+hb*(Bb-mu*Cmb)'
  #  derivative_order = 2
  #  outputs = exodus
  #[../]
  [./Cma_dha]
    type = ParsedMaterial
    f_name = Cma_dha
    material_property_names = 'Cma k'
    function = 'Cma*k'
  [../]
  [./Cmb_dhb]
    type = ParsedMaterial
    f_name = Cmb_dhb
    material_property_names = 'Cmb k'
    function = 'Cmb*k'
  [../]
  [./ha]
    type = DerivativeParsedMaterial
    f_name = ha
    args = 'p'
    function = 'p^3*(10-15*p+6*p^2)'
    derivative_order = 2
    outputs = exodus
  [../]
  [./hb]
    type = DerivativeParsedMaterial
    f_name = hb
    args = 'p'
    function = '1-p^3*(10-15*p+6*p^2)'
    derivative_order = 2
    outputs = exodus
  [../]
  [./grandpotnetial_a]
    type = DerivativeParsedMaterial
    f_name = gpot_a
    args = 'mu'
    material_property_names = 'Cma Ba'
    function = 'Ba-mu*Cma'
    outputs = exodus
  [../]
  [./grandpotnetial_b]
    type = DerivativeParsedMaterial
    f_name = gpot_b
    args = 'mu'
    material_property_names = 'Cmb Bb'
    function = 'Bb-mu*Cmb'
    outputs = exodus
  [../]
  [./constants]
    type = GenericConstantMaterial
    prop_names  = 'L     kappa_p  w       M0    k   Cma Ba  Cmb Bb'
    prop_values = '0.121 1.834e-6 8.833e5 1e-13 1e7 1.0 0.0 0.0 0.0'
    #prop_values = '0.0121  1.834e-6 8.833e5 1e-13 1e7 1.0 0.0 0.0 0.0'
  [../]
  [./compo_material]
    type = ParsedMaterial
    f_name = compo_material
    material_property_names = 'ha hb k Cma Cmb'
    args = 'p mu'
    function = '(mu/k+Cma)*ha+(mu/k+Cmb)*hb'
    outputs = exodus
  [../]
  [./mobility_function]
    type = ParsedMaterial
    f_name = Mob
    material_property_names = 'M0'
    args = 'p'
    constant_names = 'ampl'
    constant_expressions = '0'
    function = 'M0*(1+ampl*p^2*(1-p)^2/0.5^4)'
    outputs = exodus
  [../]
  #[./chempot_material]
  #  type = ParsedMaterial
  #  f_name = mu_mat
  #  args = 'mu'
  #  function = 'mu'
  #[../]
[]

[Preconditioning]
  [./cw_coupling]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  scheme = bdf2

  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm      lu          '

  l_max_its = 20
  l_tol = 1e-7
  nl_max_its = 20
  nl_rel_tol = 1e-7
  line_search = none

  dt = 1e-6
  #end_time = 20.0
  #end_time = 2000000.0
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-6
    optimal_iterations = 5
    iteration_window = 2
  [../]
[]

[Outputs]
  exodus = true
  print_perf_log = true
[]
