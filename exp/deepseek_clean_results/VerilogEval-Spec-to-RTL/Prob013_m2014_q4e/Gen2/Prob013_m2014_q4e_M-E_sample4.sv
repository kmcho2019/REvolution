module TopModule (
    input in1,
    input in2,
    output out
);
    // Transistor-level implementation of NOR gate
    wire out_n;
    
    // Pull-up network (PMOS transistors in series)
    pmos p1(out_n, 1'b1, in1);
    pmos p2(out_n, out_n, in2);
    
    // Pull-down network (NMOS transistors in parallel)
    nmos n1(out_n, 1'b0, in1);
    nmos n2(out_n, 1'b0, in2);
    
    // Output buffer
    assign out = out_n;
endmodule