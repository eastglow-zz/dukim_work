
#
# Simple diffusion
#

# diffusivity, D: 1e-7

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 150
  ny = 150
  xmax = 1.5 #mm
  ymax = 1.5 #mm
[]

[Variables]
  [./c] #phase-field variable
    order = FIRST
    family = LAGRANGE
  [../]
  #[./mu] #chemical potential variable
  #  order = FIRST
  #  family = LAGRANGE
  #[../]
[]

#[AuxVariables]
#  [./D]
#    order = FIRST
#    family = LAGRANGE
#  [../]
#[]

[ICs]
  [./MyIc1]
    type = SmoothCircleIC
    variable = c
    x1 = 0.75  #mm
    y1 = 0.75  #mm
    radius = 10e-2
    int_width = 5e-2
    invalue = 1.0
    outvalue = 0.0
  [../]
#  [./Diffusivity_field]
#    type = FunctionIC
#    variable = D
#    function = Diffu_function
#  [../]
[]

[Functions]
  [./Diffu_function]
    type = ParsedFunction
    vars = 'D0'
    vals = '1e-7'
    #value = 'D0*(x-1.2)^2 + 1e-14'
    #value = 'D0'
    value = 'r:=x;if(r<=1.2,D0,0.0)'
  [../]
[]

[BCs]
  #Do nothing means no-flux boundary condition
[]

#[AuxKernels]
#  [./Diffusivity_field]
#    type = FunctionAux
#    variable = D
#    function = Diffu_function
#    execute_on = TIMESTEP_BEGIN
#  [../]
#[]

[Kernels]
  [./time_derivative_p]
    type = TimeDerivative
    variable = c
  [../]
  [./Div_flux]
    type = ACInterface
    variable = c
    mob_name = L
    kappa_name = DiffuF
  [../]
[]

[Materials]
  [./mat]
    type = GenericConstantMaterial
    prop_names  = 'L'
    prop_values = '1.0'
  [../]

  #[./Diffu]
  #  type = ParsedMaterial
  #  f_name = Diffu
  #  args = D
  #  function = 'D'
  #[../]
  [./Diffu]
    type = GenericFunctionMaterial
    prop_names = 'DiffuF'
    prop_values = 'Diffu_function'
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
  solve_type = PJFNK
  scheme = bdf2

  petsc_options_iname = '-pc_type -sub_pc_type'
  petsc_options_value = 'asm      lu          '

  l_max_its = 30
  l_tol = 1e-7
  #l_tol = 1e-10
  nl_max_its = 20
  nl_rel_tol = 1e-9

  dt = 1e-3
  #end_time = 20.0
  #end_time = 2000000.0
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-3
    optimal_iterations = 5
    iteration_window = 2
  [../]
[]

[Outputs]
  exodus = true
  print_perf_log = true
[]
