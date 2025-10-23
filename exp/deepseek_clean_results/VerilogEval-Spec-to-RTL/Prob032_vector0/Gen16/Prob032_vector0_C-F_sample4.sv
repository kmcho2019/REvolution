module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Direct vector output assignment
    assign outv = vec;
    
    // Explicit bit mapping with consistent syntax
    assign {o2, o1, o0} = vec;

endmodule