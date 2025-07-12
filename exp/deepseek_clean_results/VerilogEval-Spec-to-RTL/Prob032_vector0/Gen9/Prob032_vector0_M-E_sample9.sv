module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Buffer for each bit of the vector output
    buf b0(outv[0], vec[0]);
    buf b1(outv[1], vec[1]);
    buf b2(outv[2], vec[2]);

    // Buffers for individual outputs
    buf b3(o0, vec[0]);
    buf b4(o1, vec[1]);
    buf b5(o2, vec[2]);

endmodule