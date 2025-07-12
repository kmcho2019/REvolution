module TopModule(
    input a,
    input b,
    output out
);
    // Transmission gate AND implementation
    supply1 vdd;
    supply0 gnd;
    
    // PMOS: Pulls output high when both inputs are high
    pmos p1(out, vdd, a);
    pmos p2(out, vdd, b);
    
    // NMOS: Pulls output low when either input is low
    nmos n1(out, gnd, ~a);
    nmos n2(out, gnd, ~b);
    
    // Weak keeper to maintain state when both paths are off
    tranif1 wk(out, out, 1'b1);
endmodule