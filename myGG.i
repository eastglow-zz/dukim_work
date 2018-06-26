[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 512
  ny = 512
  xmin = 0
  xmax = 51.2e-6
  ymin = 0
  ymax = 51.2e-6
[]

[GlobalParams]
  op_num = 10
     #Works in:
     #  'PolycrystalVariables' in [Variables] section
     #  'ACGrGrMulti' in [Kernels] section
  #var_name_base = p  #parameters for 'PolycrystalVariables' in '[Variables] section'
  #int_width = 0.5e-6
[]

[Variables]
  #[./PolycrystalVariables]
  #[../]
  [./p0]  #0th grain
  [../]
  [./p1]  #1st grain
  [../]
  [./p2]  #2nd grain
  [../]
  [./p3]  #2nd grain
  [../]
  [./p4]  #2nd grain
  [../]
  [./p5]  #2nd grain
  [../]
  [./p6]  #2nd grain
  [../]
  [./p7]  #2nd grain
  [../]
  [./p8]  #2nd grain
  [../]
  [./p9]  #2nd grain
  [../]
[]

#[AuxVariables]
#  [./bnds]
#    order = FIRST
#    family = LAGRANGE
#  [../]
#[]

[ICs]
  [./nuclei0]
    #type = SmoothCircleIC
    #variable = p0
    #x1 = 9.10e-6
    #y1 = 7.50e-6
    #radius = 2.0e-6
    #invalue = 1.0
    #outvalue = 0.0
    type = BoundingBoxIC
    variable = p0
    x1 = 18.2e-6
    x2 = 20.2e-6
    y1 = 33.8e-6
    y2 = 35.8e-6
    #x1 = 23.6e-6
    #x2 = 27.6e-6
    #y1 = 23.6e-6
    #y2 = 27.6e-6
    inside = 1.0
    outside = 0.0
  [../]
  [./nuclei1]
    #type = SmoothCircleIC
    #variable = p1
    #x1 = 1.36e-5
    #y1 = 1.08e-5
    #radius = 2.0e-6
    #invalue = 1.0
    #outvalue = 0.0
    type = BoundingBoxIC
    variable = p1
    #x1 = 11.6e-6
    #x2 = 15.6e-6
    #y1 = 8.8e-6
    #y2 = 12.8e-6
    #inside = 0.0
    #outside = 0.0
    x1 = 43.3e-6
    x2 = 45.3e-6
    y1 = 27.8e-6
    y2 = 29.8e-6
    inside = 1.0
    outside = 0.0
  [../]
  [./nuclei2]
    #type = SmoothCircleIC
    #variable = p2
    #x1 = 4.75e-5
    #y1 = 4.78e-5
    #radius = 2.0e-6
    #invalue = 1.0
    #outvalue = 0.0
    type = BoundingBoxIC
    variable = p2
    x1 = 1.5e-6
    x2 = 3.5e-6
    y1 = 15.4e-6
    y2 = 17.4e-6
    inside = 1.0
    outside = 0.0
  [../]
  [./nuclei3]
    type = BoundingBoxIC
    variable = p3
    x1 = 5.9e-6
    x2 = 7.9e-6
    y1 = 31.1e-6
    y2 = 33.1e-6
    inside = 1.0
    outside = 0.0
  [../]
  [./nuclei4]
    type = BoundingBoxIC
    variable = p4
    x1 = 48.2e-6
    x2 = 50.2e-6
    y1 = 9.1e-6
    y2 = 11.1e-6
    inside = 1.0
    outside = 0.0
  [../]
  [./nuclei5]
    type = BoundingBoxIC
    variable = p5
    x1 = 3.2e-6
    x2 = 5.2e-6
    y1 = 17.7e-6
    y2 = 19.7e-6
    inside = 1.0
    outside = 0.0
  [../]
  [./nuclei6]
    type = BoundingBoxIC
    variable = p6
    x1 = 41.0e-6
    x2 = 43.0e-6
    y1 = 3.8e-6
    y2 = 5.8e-6
    inside = 1.0
    outside = 0.0
  [../]
  [./nuclei7]
    type = BoundingBoxIC
    variable = p7
    x1 = 18.7e-6
    x2 = 20.7e-6
    y1 = 24.2e-6
    y2 = 26.2e-6
    inside = 1.0
    outside = 0.0
  [../]
  [./nuclei8]
    type = BoundingBoxIC
    variable = p8
    x1 = 6.4e-6
    x2 = 8.4e-6
    y1 = 21.7e-6
    y2 = 23.7e-6
    inside = 1.0
    outside = 0.0
  [../]
  [./nuclei9]
    type = BoundingBoxIC
    variable = p9
    x1 = 14.7e-6
    x2 = 16.7e-6
    y1 = 24.6e-6
    y2 = 26.6e-6
    inside = 1.0
    outside = 0.0
  [../]
[]

[BCs]
  [./Periodic]
    [./All]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Kernels]
  #Residual terms for p0
  [./TimeDerv0]
    type = TimeDerivative
    variable = p0
  [../]
  [./Doublewell0]
    type = ACGrGrMulti
    variable = p0
    v =           'p1 p2 p3 p4 p5 p6 p7 p8 p9'
    gamma_names = 'g0 g0 g0 g0 g0 g0 g0 g0 g0'
  [../]
  [./GradE0]
    type = ACInterface
    variable = p0
    kappa_name = kappa  # I don't know why 'kappa' is written in black color instead of as a string.
  [../]
  #[./DrivF0]
  #  type = ACSwitching
  #  variable = p0
  #  Fj_names = 'DF0'  #Driving force function will be specified in the [Materials] section
  #  hj_names = 'h0'  #The switching function will be specified in the [Materials] section
  #  args = 'p1 p2'
  #[../]

  #Residual terms for p1
  [./TimeDerv1]
    type = TimeDerivative
    variable = p1
  [../]
  [./Doublewell1]
    type = ACGrGrMulti
    variable = p1
    v =           'p0 p2 p3 p4 p5 p6 p7 p8 p9'
    gamma_names = 'g0 g0 g0 g0 g0 g0 g0 g0 g0'
  [../]
  [./GradE1]
    type = ACInterface
    variable = p1
    kappa_name = kappa  # I don't know why 'kappa' is written in black color instead of as a string.
  [../]
  #[./DrivF1]
  #  type = ACSwitching
  #  variable = p1
  #  Fj_names = 'DF1'  #Driving force function will be specified in the [Materials] section
  #  hj_names = 'h1'  #The switching function will be specified in the [Materials] section
  #  args = 'p0 p2'
  #[../]

  #Residual terms for p2
  [./TimeDerv2]
    type = TimeDerivative
    variable = p2
  [../]
  [./Doublewell2]
    type = ACGrGrMulti
    variable = p2
    v =           'p0 p1 p3 p4 p5 p6 p7 p8 p9'
    gamma_names = 'g0 g0 g0 g0 g0 g0 g0 g0 g0'
  [../]
  [./GradE2]
    type = ACInterface
    variable = p2
    kappa_name = kappa  # I don't know why 'kappa' is written in black color instead of as a string.
  [../]
  #[./DrivF2]
  #  type = ACSwitching
  #  variable = p2
  #  Fj_names = 'DF2'  #Driving force function will be specified in the [Materials] section
  #  hj_names = 'h2'  #The switching function will be specified in the [Materials] section
  #  args = 'p0 p1'
  #[../]
  #Residual terms for p3
  [./TimeDerv3]
    type = TimeDerivative
    variable = p3
  [../]
  [./Doublewell3]
    type = ACGrGrMulti
    variable = p3
    v =           'p0 p1 p2 p4 p5 p6 p7 p8 p9'
    gamma_names = 'g0 g0 g0 g0 g0 g0 g0 g0 g0'
  [../]
  [./GradE3]
    type = ACInterface
    variable = p3
    kappa_name = kappa  # I don't know why 'kappa' is written in black color instead of as a string.
  [../]

  #Residual terms for p4
  [./TimeDerv4]
    type = TimeDerivative
    variable = p4
  [../]
  [./Doublewell4]
    type = ACGrGrMulti
    variable = p4
    v =           'p0 p1 p2 p3 p5 p6 p7 p8 p9'
    gamma_names = 'g0 g0 g0 g0 g0 g0 g0 g0 g0'
  [../]
  [./GradE4]
    type = ACInterface
    variable = p4
    kappa_name = kappa  # I don't know why 'kappa' is written in black color instead of as a string.
  [../]

  #Residual terms for p5
  [./TimeDerv5]
    type = TimeDerivative
    variable = p5
  [../]
  [./Doublewell5]
    type = ACGrGrMulti
    variable = p5
    v =           'p0 p1 p2 p3 p4 p6 p7 p8 p9'
    gamma_names = 'g0 g0 g0 g0 g0 g0 g0 g0 g0'
  [../]
  [./GradE5]
    type = ACInterface
    variable = p5
    kappa_name = kappa  # I don't know why 'kappa' is written in black color instead of as a string.
  [../]

  #Residual terms for p6
  [./TimeDerv6]
    type = TimeDerivative
    variable = p6
  [../]
  [./Doublewell6]
    type = ACGrGrMulti
    variable = p6
    v =           'p0 p1 p2 p3 p4 p5 p7 p8 p9'
    gamma_names = 'g0 g0 g0 g0 g0 g0 g0 g0 g0'
  [../]
  [./GradE6]
    type = ACInterface
    variable = p6
    kappa_name = kappa  # I don't know why 'kappa' is written in black color instead of as a string.
  [../]

  #Residual terms for p7
  [./TimeDerv7]
    type = TimeDerivative
    variable = p7
  [../]
  [./Doublewell7]
    type = ACGrGrMulti
    variable = p7
    v =           'p0 p1 p2 p3 p4 p5 p6 p8 p9'
    gamma_names = 'g0 g0 g0 g0 g0 g0 g0 g0 g0'
  [../]
  [./GradE7]
    type = ACInterface
    variable = p7
    kappa_name = kappa  # I don't know why 'kappa' is written in black color instead of as a string.
  [../]

  #Residual terms for p8
  [./TimeDerv8]
    type = TimeDerivative
    variable = p8
  [../]
  [./Doublewell8]
    type = ACGrGrMulti
    variable = p8
    v =           'p0 p1 p2 p3 p4 p5 p6 p7 p9'
    gamma_names = 'g0 g0 g0 g0 g0 g0 g0 g0 g0'
  [../]
  [./GradE8]
    type = ACInterface
    variable = p8
    kappa_name = kappa  # I don't know why 'kappa' is written in black color instead of as a string.
  [../]

  #Residual terms for p9
  [./TimeDerv9]
    type = TimeDerivative
    variable = p9
  [../]
  [./Doublewell9]
    type = ACGrGrMulti
    variable = p9
    v =           'p0 p1 p2 p3 p4 p5 p6 p7 p8'
    gamma_names = 'g0 g0 g0 g0 g0 g0 g0 g0 g0'
  [../]
  [./GradE9]
    type = ACInterface
    variable = p9
    kappa_name = kappa  # I don't know why 'kappa' is written in black color instead of as a string.
  [../]
[]

#[AuxKernels]
#  [./GB_draw]
#    type = BndsCalcAux
#    variable = bnds
#    v = 'p0 p1 p2'
#    var_name_base = GBc
#    execute_on = timestep_end
#  [../]
#[]

[Materials]
  [./constants]
    type = GenericConstantMaterial
    prop_names =  'kappa    mu     L    DF0   DF1   DF2   g0'
    prop_values = '2.81e-7  9.0e6  1.0  -1e7  -1e7  -1e7  1.5'
  [../]

  [./h0]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = h0
    all_etas = 'p0 p1 p2 p3 p4 p5 p6 p7 p8 p9'
    phase_etas = 'p0'
  [../]

  [./h1]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = h1
    all_etas = 'p0 p1 p2 p3 p4 p5 p6 p7 p8 p9'
    phase_etas = 'p1'
  [../]

  [./h2]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = h2
    all_etas = 'p0 p1 p2 p3 p4 p5 p6 p7 p8 p9'
    phase_etas = 'p2'
  [../]

  [./h3]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = h3
    all_etas = 'p0 p1 p2 p3 p4 p5 p6 p7 p8 p9'
    phase_etas = 'p3'
  [../]

  [./h4]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = h4
    all_etas = 'p0 p1 p2 p3 p4 p5 p6 p7 p8 p9'
    phase_etas = 'p4'
  [../]

  [./h5]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = h5
    all_etas = 'p0 p1 p2 p3 p4 p5 p6 p7 p8 p9'
    phase_etas = 'p5'
  [../]

  [./h6]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = h6
    all_etas = 'p0 p1 p2 p3 p4 p5 p6 p7 p8 p9'
    phase_etas = 'p6'
  [../]

  [./h7]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = h7
    all_etas = 'p0 p1 p2 p3 p4 p5 p6 p7 p8 p9'
    phase_etas = 'p7'
  [../]

  [./h8]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = h8
    all_etas = 'p0 p1 p2 p3 p4 p5 p6 p7 p8 p9'
    phase_etas = 'p8'
  [../]

  [./h9]
    type = SwitchingFunctionMultiPhaseMaterial
    h_name = h9
    all_etas = 'p0 p1 p2 p3 p4 p5 p6 p7 p8 p9'
    phase_etas = 'p9'
  [../]
[]

[Postprocessors]
  [./dt]
    type = TimestepSize
  [../]
  #[./GBvisual]
  #  type = FeatureFloodCount
  #  variable = bnds
  #  threshold = 0.5
  #[../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  nl_max_its = 15
  scheme = bdf2   #Time derivative differenciation scheme
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -sub_pc_type'   # ???
  petsc_options_value = 'asm      lu'            # ???
  l_max_its = 15
  l_tol = 1.0e-3
  nl_rel_tol = 1e-8
  start_time = 0
  end_time = 20e-7
  nl_abs_tol = 1e-10

  [./TimeStepper]  #I have no idea
    type = IterationAdaptiveDT
    dt = 1e-7
    optimal_iterations = 3
    #iteration_window = 0.2e-7
  [../]
[]

[Outputs]
  [./out_exodus]
    type = Exodus
    interval = 1   # What's the unit? # of step? or time?
  [../]
  checkpoint = true
  csv = true
[]
