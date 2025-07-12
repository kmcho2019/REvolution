module TopModule(
    input [2:0] vec,  // 3-bit input vector
    output [2:0] outv,  // 3-bit output vector
    output o2,  // output bit 2
    output o1,  // output bit 1
    output o0   // output bit 0
);

// Assign input vector to output vector
assign outv = vec;

// Split input vector into individual bits
assign o0 = vec[0];
assign o1 = vec[1];
assign o2 = vec[2];

endmodule