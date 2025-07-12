module TopModule(
    input a,
    input b,
    output out
);
    wire out_n;
    
    // PMOS pull-up network (conducts when gate is low)
    pmos p1(out, 1'b1, a);
    pmos p2(out, 1'b1, b);
    
    // NMOS pull-down network (conducts when gate is high)
    nmos n1(out, out_n, a);
    nmos n2(out_n, 1'b0, b);
endmodule