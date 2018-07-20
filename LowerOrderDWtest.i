
# Simple 1D Allen-Cahn eqn. with the lower order double-well function like abs(p)*abs(1-p)
# abs(x) has been approxamated as (sqrt(x^2 + eps^2) - eps) to avoid the singularity at x = 0, where eps is a small positive number


[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmax = 100
  ymax = 100
[]

[Variables]
  [./p]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[ICs]
  [./boxIC]
    type = BoundingBoxIC
    variable = p
    x1 = 30
    x2 = 70
    y1 = 30
    y2 = 70
    inside = 1
    outside = 0
  [../]
[]

[BCs]
  #no-flux BC
[]

[Kernels]
  [./pdot]
    type = TimeDerivative
    variable = p
  [../]
  [./GradE]
    type = SimpleACInterface
    variable = p
    kappa_name = kappa_p
    mob_name = L
  [../]
  [./double_well_term]
    type = AllenCahn
    variable = p
    f_name = fDW_LO
    mob_name = L
  [../]
[]

[Materials]
  [./constants]
    type = GenericConstantMaterial
    prop_names =  'L kappa_p w0'
    prop_values = '1 5       1'
  [../]
  [./double_well_material]
    type = DerivativeParsedMaterial
    f_name = fDW_LO
    material_property_names = 'w0'
    constant_names =       'eps'
    constant_expressions = '0.01'
    args = 'p'
    function = 'w0*((sqrt(p^2 + eps^2)-eps)*(sqrt((1-p)^2 + eps^2)-eps))'
    derivative_order = 2
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

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
  #petsc_options_iname = '-pc_type -sub_pc_type'
  #petsc_options_value = 'asm      lu          '
  #petsc_options_iname = '-pc_type -pc_asm_overlap'
  #petsc_options_value = 'asm      1'

  #petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_levels'
  #petsc_options_value = 'bjacobi  ilu          4'

  l_max_its = 50
  l_tol = 1e-5
  nl_max_its = 20
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-6
    cutback_factor = 0.5
    growth_factor = 2.0
    optimal_iterations = 20
    iteration_window = 5
  [../]
  dtmax = 1
  #end_time = 20.0
  #end_time = 2000.0

  # adaptive mesh to resolve an interface
  # [./Adaptivity]
  #   initial_adaptivity = 2
  #   max_h_level = 2
  #   refine_fraction = 0.95
  #   coarsen_fraction = 0.10
  #   weight_names =  'cL cV cS'
  #   weight_values = '1  1  1'
  #
  # [../]
[]

[Outputs]
  exodus = true
  #interval = 20
[]
