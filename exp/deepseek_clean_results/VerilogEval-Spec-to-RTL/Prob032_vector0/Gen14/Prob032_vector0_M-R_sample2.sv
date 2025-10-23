module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Pass-through vector output
    assign outv = vec;

    // Vector bit decomposition:
    // MSB first ordering matches vector indices
    assign o2 = vec[2];  // Bit 2 (MSB)
    assign o1 = vec[1];  // Bit 1 
    assign o0 = vec[0];  // Bit 0 (LSB)

endmodule