module TopModule(
    input  [2:0] vec,  // 3-bit input vector
    output [2:0] outv, // 3-bit output vector
    output        o2,  // 1-bit output
    output        o1,  // 1-bit output
    output        o0   // 1-bit output
);

// Assign the input vector to the output vector
assign outv = vec;

// Split the input vector into individual bits and assign to outputs
assign o2 = vec[2];
assign o1 = vec[1];
assign o0 = vec[0];

endmodule