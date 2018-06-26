


[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 150
  ny = 150
  xmax = 60
  ymax = 60
[]

[Modules]
  [./PhaseField]
    [./Conserved]
      [./c]
        free_energy = fbulk
        mobility = M
        kappa = kappa_c
        solve_type = DIRECT
      [../]
    [../]
  [../]
[]

[AuxVariables]
  [./local_energy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[ICs]
  [./cIC]
    type = RandomIC
    variable = c
    #min = -0.1
    #max =  0.1
    min = 0.45
    max = 0.55
  [../]
  #[./MyIc1]
  #  type = SpecifiedSmoothCircleIC
  #  variable = c
  #  x_positions = '40 15 45'
  #  y_positions = '30 15  2'
  #  z_positions = ' 0  0  0'
  #  radii = '3  2  5'
  #  invalue =  1.0
  #  outvalue = 0.1
  #[../]
[]

[AuxKernels]
  [./local_energy]
    type = TotalFreeEnergy
    variable = local_energy
    f_name = fbulk
    interfacial_vars = c
    kappa_names = kappa_c
    execute_on = timestep_end
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Materials]
  [./mat]
    type = GenericConstantMaterial
    prop_names  = 'M kappa_c'
    #prop_values = '1.0 0.5'
    prop_values = '0.75 1.0'
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = c
    constant_names = 'W kbT'
    #constant_names = chem_pot
    #constant_expressions = 1.0/2^2
    constant_expressions = '1 0.1'
    #const_names = kbt
    #constant_expressions = 0.1
    #function = W*(1-c)^2*(1+c)^2
    #function = chem_pot*(1-c)^2*(1+c)^2
    #function = chem_pot*(c)^2*(1-c)^2
    function = W*c*(1-c)+kbT*(c*plog(c,1e-4)+(1-c)*plog(1-c,1e-4))
    enable_jit = true
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

  [./total_free_energy]
    type = ElementIntegralVariablePostprocessor
    variable = local_energy
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  scheme = bdf2

  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm      lu          '

  l_max_its = 30
  l_tol = 1e-4
  nl_max_its = 20
  nl_rel_tol = 1e-9

  dt = 2.0
  #end_time = 20.0
  end_time = 20.0
[]

[Outputs]
  exodus = true
  print_perf_log = true
  csv = true
[]
