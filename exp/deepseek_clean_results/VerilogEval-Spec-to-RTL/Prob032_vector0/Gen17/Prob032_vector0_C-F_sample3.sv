module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);
    
    // Direct continuous assignments
    assign outv = vec;          // Full vector output
    assign o2 = vec[2];         // Bit 2 output
    assign o1 = vec[1];         // Bit 1 output
    assign o0 = vec[0];         // Bit 0 output

endmodule