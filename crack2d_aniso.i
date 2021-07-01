[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  type = FileMesh
  file = crack_mesh.e
  uniform_refine = 2
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./c]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./dcx]
    order = FIRST
    family = MONOMIAL
  [../]
  [./dcy]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./pfbulk]
    type = AllenCahn
    variable = c
    mob_name = M
    f_name = E_el
  [../]
  # [./ac_pf]
  #   type = AllenCahnPFFracture
  #   l_name = l
  #   visco_name = visco
  #   gc = gc_prop
  #   displacements = 'disp_x disp_y'
  #   F_name = F
  #   variable = c
  # [../]
  [./TensorMechanics]
    displacements = 'disp_x disp_y'
  [../]
  [./solid_x]
    type = PhaseFieldFractureMechanicsOffDiag
    variable = disp_x
    component = 0
    c = c
  [../]
  [./solid_y]
    type = PhaseFieldFractureMechanicsOffDiag
    variable = disp_y
    component = 1
    c = c
  [../]
  [./dcdt]
    type = TimeDerivative
    variable = c
  [../]
  [./InterfacialE]
    type = AnisotropicGradEnergy
    variable = c
    mob_name = M
    kappa_name = Wsq_aniso
    gradient_component_names = 'dcx dcy'
  [../]
  # [./anisoACinterface3]
  #   type = ACInterfacePFFrac
  #   variable = c
  #   mob_name = L
  #   eps_name = eps
  #   l_name = l
  # [../]
[]

[AuxKernels]
  [./stress_yy]
    type = RankTwoAux
    variable = stress_yy
    rank_two_tensor = stress
    index_j = 1
    index_i = 1
    execute_on = timestep_end
  [../]
  [./get_dcx]
    type = VariableGradientComponent
    variable = dcx
    gradient_variable = c
    component = x
    # execute_on = LINEAR
  [../]
  [./get_dcy]
    type = VariableGradientComponent
    variable = dcy
    gradient_variable = c
    component = y
    # execute_on = LINEAR
  [../]
[]

[BCs]
  [./ydisp]
    type = FunctionPresetBC
    variable = disp_y
    boundary = 2
    function = 't'
  [../]
  [./yfix]
    type = PresetBC
    variable = disp_y
    boundary = '1'
    value = 0
  [../]
  [./xfix]
    type = PresetBC
    variable = disp_x
    boundary = 1
    value = 0
  [../]
[]

[Materials]
  [./pfbulkmat]
    type = GenericConstantMaterial
    prop_names = 'gc_prop l visco eps_bar delta M'
    prop_values = '9e-4 0.02 1e-6 3e-2 0.5 1e6'
  [../]
  [./Anisotropic_Wsquare]
    type = DerivativeParsedMaterial
    f_name = Wsq_aniso
    material_property_names = 'gc_prop delta l'
    args = 'dcx dcy'
    function = 'gc_prop * l * (1 + delta * (dcx^2 - dcy^2)/(dcx^2 + dcy^2))^2'
    derivative_order = 2
  [../]
  #To prevent divided by zero
  [./eps4]
    type = ParsedMaterial
    f_name = eps4
    material_property_names = 'eps_bar'
    args = 'c'
    function = 'if((0.95-c)*(0.95+c) >= 0, eps_bar, 0)'
  [../]
  [./elastic]
    type = ComputeLinearElasticPFFractureStress
    kdamage = 1e-6
    c = c
    F_name = E_el
    use_current_history_variable = true
  [../]
  [./elasticity_tensor]
    type = ComputeElasticityTensor
    C_ijkl = '120.0 80.0'
    fill_method = symmetric_isotropic
  [../]
  [./strain]
    type = ComputeSmallStrain
  [../]
  # [./FEdensity_material]
  #   type = ParsedMaterial
  #   f_name = f_density
  #   material_property_names = 'Wsq_aniso'
  #   args = 'dpx dpy'
  #   function = '0.5*Wsq_aniso*(dpx^2+dpy^2)'
  #   #outputs = exodus
  # [../]
[]

[Preconditioning]
  active = 'SMP'
  [./SMP]
    type = SMP
    full = true
  [../]
  # [./FDP]
  #   type = FDP
  #   full = true
  # [../]
[]
[Postprocessors]
  #[./resid_x]
  #  type = NodalSum
  #  variable = resid_x
  #  boundary = 2
  #[../]
  #[./resid_y]
  #  type = NodalSum
  #  variable = resid_y
  #  boundary = 2
  #[../]
  [./disp_y_top]
    type = SideAverageValue
    variable = disp_y
    boundary = 2
  [../]
  [./stressyy]
    type = ElementAverageValue
    variable = stress_yy
  [../]
[]

[Executioner]
  type = Transient

  solve_type = PJFNK
  scheme = bdf2

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  # l_tol = 1e-5
  l_max_its = 30
  nl_max_its = 50

  dt = 5e-5
  dtmin = 1e-10
  start_time = 0.0
  end_time = 0.015
[]

[Outputs]
  file_base = Anic_30
  exodus = true
  csv = true
  gnuplot = true
[]
