module TopModule (
    input [2:0] vec,        // 3-bit input vector
    output [2:0] outv,      // Direct vector copy
    output o2, o1, o0       // Individual bit outputs
);

    // Direct vector pass-through (most efficient)
    assign outv = vec;
    
    // Bit decomposition with positional mapping
    assign {o2, o1, o0} = vec;  // o2=vec[2], o1=vec[1], o0=vec[0]

endmodule