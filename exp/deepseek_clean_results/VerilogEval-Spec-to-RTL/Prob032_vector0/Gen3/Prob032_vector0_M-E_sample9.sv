module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Constant enable for vector outputs
    wire en = 1'b1;

    // Tri-state buffers for vector output
    bufif1 b2(outv[2], vec[2], en);
    bufif1 b1(outv[1], vec[1], en);
    bufif1 b0(outv[0], vec[0], en);

    // Tri-state buffers for individual outputs
    bufif1 bo2(o2, vec[2], en);
    bufif1 bo1(o1, vec[1], en);
    bufif1 bo0(o0, vec[0], en);

endmodule