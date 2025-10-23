module TopModule (
    input in1,
    input in2,
    output out
);
    // Supply nets
    supply1 vdd;
    supply0 gnd;
    
    // PMOS transistors (pull-up network)
    pmos p1(out, vdd, in1);
    pmos p2(out, vdd, in2);
    
    // NMOS transistors (pull-down network)
    nmos n1(out, gnd, in1);
    nmos n2(n1, gnd, in2);
endmodule