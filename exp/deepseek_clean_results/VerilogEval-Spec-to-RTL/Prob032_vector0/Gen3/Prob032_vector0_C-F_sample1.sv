module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Vector output (direct connection)
    assign outv = vec;

    // Individual bit outputs (MSB to LSB)
    assign o2 = vec[2];  // Bit 2 (MSB)
    assign o1 = vec[1];  // Bit 1
    assign o0 = vec[0];  // Bit 0 (LSB)

endmodule