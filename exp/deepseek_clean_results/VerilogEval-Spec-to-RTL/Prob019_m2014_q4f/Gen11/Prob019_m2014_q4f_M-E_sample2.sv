module TopModule (
    input  in1,
    input  in2,
    output out
);
    // Transmission gate implementation of AND-NOT
    wire out_n;
    
    // PMOS pass gate (active when in2 is low)
    tranif1 (out, in1, ~in2);
    
    // NMOS pull-down (active when in2 is high)
    tranif0 (out, 1'b0, in2);
endmodule