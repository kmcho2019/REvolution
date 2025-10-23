module TopModule(
    input  [2:0] vec,  // 3-bit input vector
    output [2:0] outv, // 3-bit output vector
    output       o2,   // output bit corresponding to vec[2]
    output       o1,   // output bit corresponding to vec[1]
    output       o0    // output bit corresponding to vec[0]
);

    // Assign the input vector to the output vector
    assign outv = vec;

    // Assign each bit of the input vector to the corresponding output
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule