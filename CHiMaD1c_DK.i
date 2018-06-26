#
# Example problem showing how to use the DerivativeParsedMaterial with SplitCHParsed.
#

[Mesh]
  type = FileMesh
  file = tee_mesh_DK.msh
  #uniform_refine = 3
[]

[Modules]
  [./PhaseField]
    [./Conserved]
      [./c]
        free_energy = fbulk
        mobility = M
        kappa = kappa_c
        solve_type = REVERSE_SPLIT
      [../]
    [../]
  [../]
[]

[AuxVariables]
  [./energy_density]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[ICs]
  [./cIC]
    type = FunctionIC
    function = SquareDomainIC
    variable = c
  [../]
[]

[Functions]
  [./SquareDomainIC]
    type = ParsedFunction
    value = 'c0+eps_s*(cos(0.105*x)*cos(0.11*y)+(cos(0.13*x)*cos(0.087*y))^2+cos(0.025*x-0.15*y)*cos(0.07*x-0.02*y))'
    vars = 'c0  eps_s'
    vals = '0.5 0.01'
  [../]
[]

[AuxKernels]
  [./energy_density]
    type = TotalFreeEnergy
    variable = energy_density
    f_name = fbulk
    interfacial_vars = c
    kappa_names = kappa_c
    execute_on = timestep_end
  [../]
[]

[BCs]
  #[./Periodic]
  #  [./all]
  #    auto_direction = 'x y'
  #  [../]
  #[../]
[]

[Materials]
  [./mat]
    type = GenericConstantMaterial
    prop_names  = 'M   kappa_c'
    prop_values = '5.0 2.0'
  [../]
  [./free_energy]
    type = DerivativeParsedMaterial
    f_name = fbulk
    args = c
    constant_names =       'Q   ca  cb'
    constant_expressions = '5.0 0.3 0.7'
    function =Q*(c-ca)^2*(c-cb)^2
    enable_jit = true
    outputs = exodus
  [../]
[]

[Postprocessors]
  [./ctot]
    type = ElementIntegralVariablePostprocessor
    variable = c
  [../]
  [./total_free_energy]
    type = ElementIntegralVariablePostprocessor
    variable = energy_density
  [../]

  [./endcriterion]
    type = ElementAverageTimeDerivative
    variable = energy_density
  [../]
[]

[UserObjects]
  [./end]
    type = Terminator
    expression = 'abs(endcriterion)<1e-14'
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
  #scheme = bdf2

  #petsc_options_iname = '-pc_type -sub_pc_type'
  #petsc_options_value = 'asm      lu          '
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm      31                  preonly      lu           2'

  l_max_its = 30
  l_tol = 1e-4
  nl_max_its = 50
  nl_rel_tol = 1e-8

  dt = 1.0
  #end_time = 20.0
  end_time = 500000.0
  timestep_tolerance = 1e-1

  [./TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt=1
    percent_change = 0.05
  [../]
[]

[Outputs]
  exodus = true
  sync_times = '1 5 10 20 100 200 500 1000 2000 3000 10000 400000 100000 250000 5000000'
  sync_only = true
  print_perf_log = true
  csv = true
[]
