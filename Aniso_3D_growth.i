
#
# 3D anisotropic solidification
# A. Karma and W.-J. Rappel, Phys. Rev. E., 57 (1998) 4323 Fig. 16
# Dong-Uk Kim
# 07/06/2018

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 20
  ny = 20
  nz = 20
  xmax = 128
  ymax = 128
  zmax = 128
[]

[Variables]
  [./p] #phase-field variable
    order = FIRST
    family = LAGRANGE
  [../]
  [./u] #dimensionless temperature variable
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./dpx]
    order = FIRST
    family = MONOMIAL
  [../]
  [./dpy]
    order = FIRST
    family = MONOMIAL
  [../]
  [./dpz]
    order = FIRST
    family = MONOMIAL
  [../]

  # [./FEdensity]
  #   order = FIRST
  #   family = MONOMIAL
  # [../]
[]

[ICs]
  [./p_circleIC]
    type = SmoothCircleIC
    variable = p
    x1 = 0
    y1 = 0
    z1 = 0
    radius = 8
    int_width = 3
    invalue = 1.0
    outvalue = -1.0
  [../]
  [./u_constantIC]
    type = ConstantIC
    variable = u
    value = -0.3
  [../]
[]

[BCs]
  #Do nothing means no-flux boundary condition
  [./zeroBC]
    type = DirichletBC
    variable = u
    value = -0.3
    boundary = 'top right front'
  [../]
[]

[AuxKernels]
  [./get_dpx]
    type = VariableGradientComponent
    variable = dpx
    gradient_variable = p
    component = x
    execute_on = LINEAR
  [../]
  [./get_dpy]
    type = VariableGradientComponent
    variable = dpy
    gradient_variable = p
    component = y
    execute_on = LINEAR
  [../]
  [./get_dpz]
    type = VariableGradientComponent
    variable = dpz
    gradient_variable = p
    component = z
    execute_on = LINEAR
  [../]
[]

[Kernels]
  #Phase-field
  [./time_derivative_p]
    type = AnisotropicTimeDerivative
    variable = p
    tau_name = tau_aniso
    gradmag_threshold = 1e-4
    gradient_component_names = 'dpx dpy dpz'
  [../]
  [./InterfacialE]
    type = AnisotropicGradEnergy
    variable = p
    mob_name = L
    kappa_name = Wsq_aniso
    gradmag_threshold = 1e-4
    gradient_component_names = 'dpx dpy dpz'
  [../]
  [./localFE]
    type = AllenCahn
    variable = p
    f_name = f_doublewell
    mob_name = L
  [../]
  [./DrivingForce]
    type = ACSwitching
    variable = p
    Fj_names = 'lambda_U'
    hj_names = 'h'
    args = 'p u'
    mob_name = L
  [../]

  #Dimensionless temperature field
  [./time_derivative_u]
    type = TimeDerivative
    variable = u
  [../]
  [./div_grad_mu]
    type = ACInterface
    variable = u
    mob_name = L
    kappa_name = D
    variable_L = false
  [../]
  [./Partition_term]
    type = CoupledSwitchingTimeDerivative
    variable = u
    v = p
    Fj_names = 'oneovertwo'
    hj_names = 'switching_U'
    args =     'p'
  [../]
[]

[Materials]
  [./f_doublewell]
    type = DerivativeParsedMaterial
    f_name = f_doublewell
    args = 'p'
    function = '-0.5*p^2+0.25*p^4'
    derivative_order = 2
    #outputs = exodus
  [../]

  [./lambda_U]
    type = DerivativeParsedMaterial
    f_name = lambda_U
    material_property_names = 'lambda'
    args = 'u'
    function = 'lambda*u'
  [../]

  [./h]
    type = DerivativeParsedMaterial
    f_name = h
    args = 'p'
    function = 'p*(1-2*p^2/3+p^4/5)'
    derivative_order = 2
    #outputs = exodus
  [../]

  [./switching_U]
    type = DerivativeParsedMaterial
    f_name = switching_U
    args = 'p'
    function = 'p'
    derivative_order = 1
    #outputs = exodus
  [../]

  [./constants]
    type = GenericConstantMaterial
    prop_names  = 'tau0 W0 D  eps4 L oneovertwo'
    prop_values = '1    1  10 0.05 1 -0.5'
  [../]

  [./lambda]
    type = ParsedMaterial
    f_name = lambda
    material_property_names = 'D tau0 W0'
    function = 'D*tau0/0.6267/W0/W0'
  [../]

  [./Anisotropic_Wsquare]
    type = DerivativeParsedMaterial
    f_name = Wsq_aniso
    material_property_names = 'W0 eps4'
    args = 'dpx dpy dpz'
    function = 'if(sqrt(dpx^2 + dpy^2) > 1e-5, (W0*(1-3*eps4))^2 * (1 + (4*eps4/(1-3*eps4)) * (dpx^4 + dpy^4 + dpz^4)/(dpx^2 + dpy^2 + dpz^2)^2)^2, W0^2)'
    #function = '(W0*(1-3*eps4))^2 * (1 + (4*eps4/(1-3*eps4)) * (dpx^4 + dpy^4 + dpz^4)/(dpx^2 + dpy^2 + dpz^2)^2)^2'
    derivative_order = 2
    #outputs = exodus
  [../]

  [./Anisotropic_tau]
    type = DerivativeParsedMaterial
    f_name = tau_aniso
    material_property_names = 'tau0 eps4'
    args = 'dpx dpy dpz'
    function = 'if(sqrt(dpx^2 + dpy^2) > 1e-5, tau0 * (1-3*eps4)^2 * (1 + (4*eps4/(1-3*eps4)) * (dpx^4 + dpy^4 + dpz^4)/(dpx^2 + dpy^2 + dpz^2)^2)^2, tau0)'
    #function = 'tau0 * (1-3*eps4)^2 * (1 + (4*eps4/(1-3*eps4)) * (dpx^4 + dpy^4 + dpz^4)/(dpx^2 + dpy^2 + dpz^2)^2)^2'
    derivative_order = 2
    #outputs = exodus
  [../]

  # For the postprocess
  # [./solid_volume]
  #   type = ParsedMaterial
  #   f_name = solid_volume_per_element
  #   args = 'p'
  #   function = '(1 + p)/2'
  # [../]
  # [./element_volume]
  #   type = ParsedMaterial
  #   f_name = volume_per_element
  #   function = '1'
  # [../]
  # [./FEdensity_material]
  #   type = ParsedMaterial
  #   f_name = f_density
  #   material_property_names = 'Wsq_aniso f_doublewell lambda_U h'
  #   args = 'p u dpx dpy dpz'
  #   function = '0.5*Wsq_aniso*(dpx^2+dpy^2+dpz^2) + f_doublewell + lambda_U*h'
  #   #outputs = exodus
  # [../]
[]

[Preconditioning]
  #active = ''
  [./cw_coupling]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  scheme = bdf2

  #petsc_options_iname = '-pc_type -sub_pc_type'
  #petsc_options_value = 'asm      lu'
  # petsc_options_iname = '-pc_type -pc_asm_overlap'
  # petsc_options_value = 'asm      1'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'

  l_max_its = 20
  l_tol = 1e-4
  nl_max_its = 20
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-11

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.003
    growth_factor = 1.2
    cutback_factor = 0.8
  [../]
  dtmax = 0.3
  end_time = 1500

  [./Adaptivity]
    initial_adaptivity = 4
    max_h_level = 4
    refine_fraction = 0.95
    coarsen_fraction = 0.10
    weight_names = 'p u'
    weight_values = '0.5 0.5'

  [../]
[]

[Outputs]
  exodus = true
  csv = true
  print_perf_log = true
[]

#[Debug]
#  show_var_residual_norms = true
#[]

[Postprocessors]
  # [./Total_solid_volume]
  #   type = ElementIntegralMaterialProperty
  #   mat_prop = solid_volume_per_element
  # [../]
  #[./Total_volume]
  #  type = ElementIntegralMaterialProperty
  #  mat_prop = volume_per_element
  #[../]
  # [./Total_FE]
  #   type = ElementIntegralMaterialProperty
  #   mat_prop = f_density
  # [../]
  # [./Interface_location_along_x_axis]
  #   type = FindValueOnLine
  #   start_point = '0 0 0'
  #   end_point = '960 0 0'
  #   target = 0
  #   depth = 13
  #   tol = 1e-1
  #   v = p
  # [../]
[]
