module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Buffer for bit 2
    buf b2(outv[2], vec[2]);
    buf b2_single(o2, vec[2]);

    // Buffer for bit 1
    buf b1(outv[1], vec[1]);
    buf b1_single(o1, vec[1]);

    // Buffer for bit 0
    buf b0(outv[0], vec[0]);
    buf b0_single(o0, vec[0]);

endmodule