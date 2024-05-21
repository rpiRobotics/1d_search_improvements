setup = hardcoded_IK_setup_MM50_SJ2;

kin = setup.get_kin

[P, S] = setup.setup()

S_t = setup.run(P)