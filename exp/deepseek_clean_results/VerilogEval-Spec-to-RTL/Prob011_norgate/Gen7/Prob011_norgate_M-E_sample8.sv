module TopModule (
    input a,
    input b,
    output out
);
    // Internal wires
    wire a_n, b_n, nor_out;
    
    // Inverters for input signals
    not (a_n, a);
    not (b_n, b);
    
    // PMOS pull-up network (parallel)
    pmos p1(nor_out, 1'b1, a_n);
    pmos p2(nor_out, 1'b1, b_n);
    
    // NMOS pull-down network (series)
    nmos n1(nor_out, 1'b0, a);
    nmos n2(nor_out, 1'b0, b);
    
    // Output buffer
    buf (out, nor_out);
endmodule