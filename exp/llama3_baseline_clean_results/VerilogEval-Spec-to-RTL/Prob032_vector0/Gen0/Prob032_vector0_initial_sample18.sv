module TopModule(
    input [2:0] vec, // 3-bit input vector
    output [2:0] outv, // 3-bit output vector
    output o2, // 1-bit output
    output o1, // 1-bit output
    output o0  // 1-bit output
);

// Assign input vector directly to output vector
assign outv = vec;

// Bit-level extraction to assign each bit of input vector to corresponding output port
assign o0 = vec[0];
assign o1 = vec[1];
assign o2 = vec[2];

endmodule