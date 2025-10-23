module TopModule(input in, output out);
    supply1 vdd;
    supply0 gnd;
    
    // Transmission gate implementation
    tranif1 nmos_gate(out, in, vdd);  // NMOS (active when gate=1)
    tranif0 pmos_gate(out, in, gnd);   // PMOS (active when gate=0)
endmodule