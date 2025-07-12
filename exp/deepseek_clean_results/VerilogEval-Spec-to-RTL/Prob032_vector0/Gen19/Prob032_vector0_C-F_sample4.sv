module TopModule (
    input [2:0] vec,        // 3-bit input vector
    output [2:0] outv,      // 3-bit output vector copy
    output o2, o1, o0       // Individual bit outputs
);

    // Direct vector pass-through
    assign outv = vec;
    
    // Bit decomposition with explicit position mapping
    assign o2 = vec[2];     // Bit 2 (MSB)
    assign o1 = vec[1];     // Bit 1
    assign o0 = vec[0];     // Bit 0 (LSB)

endmodule