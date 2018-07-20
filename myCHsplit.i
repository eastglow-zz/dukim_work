#
# Example problem showing how to use the DerivativeParsedMaterial with SplitCHParsed.
# The free energy is identical to that from SplitCHMath, f_bulk = 1/4*(1-c)^2*(1+c)^2.
#

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 5
  ymax = 5
[]

#[Modules]
#  [./PhaseField]
#    [./Conserved]
#      [./c]
#        free_energy = fbulk
#        mobility = M
#        kappa = kappa_c
#        solve_type = REVERSE_SPLIT
#      [../]
#    [../]
#  [../]
#[]

[Variables]
  [./c]  # phase-field
    order = FIRST
    family = LAGRANGE
  [../]

  [./w]  # dF/dc
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  #[./local_energy]
  #  order = CONSTANT
  #  family = MONOMIAL
  #[../]

  [./energy_density]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[ICs]
  [./cIC]
    type = SmoothCircleIC
    variable = c
    x1 = 2.5
    y1 = 2.5
    radius = 0.5
    int_width = 0.3   #6-element size
    invalue = 0.9
    outvalue = 0.1
  [../]
[]

[AuxKernels]
  #[./local_energy]
  #  type = TotalFreeEnergy
  #  variable = local_energy
  #  f_name = fbulk
  #  interfacial_vars = c
  #  kappa_names = kappa_c
  #  execute_on = timestep_end
  #[../]

  [./energy_density]
    type = TotalFreeEnergy
    variable = energy_density
    f_name = fbulk
    interfacial_vars = c
    kappa_names = kappa_c
    execute_on = timestep_end
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
[]

[BCs]
  #[./Periodic]
  #  [./all]
  #    auto_direction = 'x y'
  #  [../]
  #[../]
  #[./zero_flux_BC]
  #  type = NeumannBC
  #  variable = c
  #  boundary = all
  #  value = 0
  #[../]
  #Do nothing means no-flux boundary condition
[]

[Materials]
  [./mat]
    type = GenericConstantMaterial
    prop_names  = 'M_c  kappa_c'
    prop_values = '1.0  0.02'
    #prop_values = '0.75 1.0'
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = c
    #constant_names = 'W kbT'
    constant_names = chem_pot
    constant_expressions = 1.0/2^2
    #constant_expressions = '1 0.1'
    #const_names = kbt
    #constant_expressions = 0.1
    #function = W*(1-c)^2*(1+c)^2
    #function = chem_pot*(1-c)^2*(1+c)^2
    function = 16*chem_pot*(c)^2*(1-c)^2
    #function = W*c*(1-c)+kbT*(c*plog(c,1e-4)+(1-c)*plog(1-c,1e-4))
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
  #[./total_free_energy]
  #  type = ElementIntegralVariablePostprocessor
  #  variable = local_energy
  #[../]
  [./total_free_energy]
    type = ElementIntegralVariablePostprocessor
    variable = energy_density
  [../]
[]

[Preconditioning]
  [./cw_coupling]
    type = SMP
    full = true
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
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 2.0
    optimal_iterations = 20
    iteration_window = 5
  [../]
  #end_time = 20.0
  #end_time = 2000.0
[]

[Outputs]
  exodus = true
  print_perf_log = true
  csv = true
[]
