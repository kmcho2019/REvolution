module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Instantiate buffers for each bit
    buf bit2_buf (.A(vec[2]), .Y(outv[2]), .Y2(o2));
    buf bit1_buf (.A(vec[1]), .Y(outv[1]), .Y2(o1));
    buf bit0_buf (.A(vec[0]), .Y(outv[0]), .Y2(o0));

endmodule