module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);
    
    // Direct vector assignment for the 3-bit output
    assign outv = vec;
    
    // Explicit bit assignments for clarity
    assign o2 = vec[2];  // MSB
    assign o1 = vec[1];  // Middle bit
    assign o0 = vec[0];  // LSB

endmodule