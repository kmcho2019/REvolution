module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Buffer for each output bit
    buf b2(outv[2], vec[2]);
    buf b1(outv[1], vec[1]);
    buf b0(outv[0], vec[0]);

    // Separate buffers for individual outputs
    buf b_o2(o2, vec[2]);
    buf b_o1(o1, vec[1]);
    buf b_o0(o0, vec[0]);

endmodule