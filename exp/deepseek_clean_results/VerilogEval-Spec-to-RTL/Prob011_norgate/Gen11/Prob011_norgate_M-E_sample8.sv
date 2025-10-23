module TopModule(
    input a,
    input b,
    output out
);
    // PMOS transistors (pull-up network)
    wire net1;
    supply1 vdd;
    pmos p1(net1, vdd, a);
    pmos p2(out, net1, b);
    
    // NMOS transistors (pull-down network)
    supply0 gnd;
    nmos n1(out, gnd, a);
    nmos n2(out, gnd, b);
endmodule