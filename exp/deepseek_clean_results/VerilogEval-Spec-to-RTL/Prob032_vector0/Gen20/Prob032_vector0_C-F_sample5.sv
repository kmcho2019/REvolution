module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);
    
    // Direct vector assignment (efficient like Example 1)
    assign outv = vec;
    
    // Explicit bit-wise outputs (clear like Example 2)
    assign {o2, o1, o0} = vec;

endmodule