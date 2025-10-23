module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly assign the 3-bit output vector from input
    assign outv = vec;

    // Assign each single-bit output individually from the input vector bits
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule