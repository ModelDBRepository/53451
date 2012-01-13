TITLE decay of internal calcium concentration
:
: Internal calcium concentration due to calcium currents and pump.
: Differential equations.
:
: Simple model of ATPase pump with 3 kinetic constants (Destexhe 92)
:     Cai + P <-> CaP -> Cao + P  (k1,k2,k3)
: A Michaelis-Menten approximation is assumed, which reduces the complexity
: of the system to 2 parameters: 
:       kt = <tot enzyme concentration> * k3  -> TIME CONSTANT OF THE PUMP
:	kd = k2/k1 (dissociation constant)    -> EQUILIBRIUM CALCIUM VALUE
: The values of these parameters are chosen assuming a high affinity of 
: the pump to calcium and a low transport capacity (cfr. Blaustein, 
: TINS, 11: 438, 1988, and references therein).  
:
: Units checked using "modlunit" -> factor 10000 needed in ca entry
:
: VERSION OF PUMP + DECAY (decay can be viewed as simplified buffering)
:
: All variables are range variables
:
:
: This mechanism was published in:  Destexhe, A. Babloyantz, A. and 
: Sejnowski, TJ.  Ionic mechanisms for intrinsic slow oscillations in
: thalamic relay neurons. Biophys. J. 65: 1538-1552, 1993)
:
: Written by Alain Destexhe, Salk Institute, Nov 12, 1992
:

INDEPENDENT {t FROM 0 TO 1 WITH 1 (ms)}

NEURON {
	SUFFIX cad
	USEION ca READ ica WRITE cai
	GLOBAL depth,cainf,taur
}

UNITS {
	(molar) = (1/liter)			: moles do not appear in units
	(mM)	= (millimolar)
	(um)	= (micron)
	(mA)	= (milliamp)
	(msM)	= (ms mM)
	FARADAY = (faraday) (coulomb)
}


PARAMETER {
	depth	= .1	(um)		: depth of shell
	taur	= 200	(ms)		: rate of calcium removal
	cainf	= 100e-6(mM)
}

STATE {
	cai		(mM) <1e-6>
}

INITIAL {
:printf("cad INITIAL entry: t=%g cai=%g ica=%g\n", t, cai, ica)
	cai = cainf	:really should be done in hoc (initialization
			: of states is consistent but not currents from
			: fcurrent() since eca comes from nernst with
			: cai0_ca_ion and cao0_ca_ion first and then
			: this initial block is called.
:printf("cad INITIAL exit: t=%g cai=%g ica=%g\n", t, cai, ica)
}

ASSIGNED {
	ica		(mA/cm2)
	drive_channel	(mM/ms)
}
	
BREAKPOINT {
	SOLVE state METHOD euler
:printf("cad BREAKPOINT entry: t=%g cai=%g ica=%g\n", t, cai, ica)
}

DERIVATIVE state { 
:printf("cad state entry: t=%g cai=%g ica=%g\n", t, cai, ica)
	: does not take into account pump current in calculation of ica
	drive_channel =  - (10000) * ica / (2 * FARADAY * depth)
	if (drive_channel <= 0.) { drive_channel = 0. }	: cannot pump inward

	cai' = drive_channel + (cainf-cai)/taur
:printf("cad state exit: t=%g cai=%g ica=%g\n", t, cai, ica)
}







