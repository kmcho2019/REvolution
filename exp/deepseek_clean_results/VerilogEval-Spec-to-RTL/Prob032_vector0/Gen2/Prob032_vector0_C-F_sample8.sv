module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Direct vector output - clear and concise
    assign outv = vec;
    
    // Multiple approaches shown for educational purposes:
    // Method 1: Direct bit assignment (most explicit)
    assign o2 = vec[2];
    
    // Method 2: Concatenation style (compact)
    assign {o1, o0} = vec[1:0];

endmodule