module TopModule (
    input in1,
    input in2,
    output out
);
    // Internal nodes
    wire out_n;
    wire pullup, pulldown;
    
    // PMOS transistors (active low) for pull-up network
    pmos p1(pullup, 1'b1, ~in1);
    pmos p2(pullup, 1'b1, ~in2);
    
    // NMOS transistors (active high) for pull-down network
    nmos n1(pulldown, 1'b0, in1);
    nmos n2(pulldown, 1'b0, in2);
    
    // Combine the networks
    tranif1 t1(out_n, pullup, ~(in1 | in2));
    tranif0 t2(out_n, pulldown, in1 | in2);
    
    // Keeper circuit to maintain state
    bufif1 keeper(out_n, out_n, ~(pullup | pulldown));
    
    // Output inversion to get correct polarity
    assign out = ~out_n;
endmodule