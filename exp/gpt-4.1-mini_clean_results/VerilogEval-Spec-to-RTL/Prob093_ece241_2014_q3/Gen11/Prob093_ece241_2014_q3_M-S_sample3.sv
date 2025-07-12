module mux2to1 (
    input sel,
    input d0,
    input d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    // mux_in[0] = c | d = mux(c, d, 1)
    mux2to1 mux0 (.sel(c), .d0(d), .d1(1'b1), .y(mux_in[0]));

    // mux_in[1] = 0 (constant)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d = mux(c, 0, d)
    mux2to1 mux2 (.sel(c), .d0(1'b0), .d1(d), .y(mux_in[2]));

    // Implement ~d = mux(d, 1, 0)
    wire not_d;
    mux2to1 inv_d (.sel(d), .d0(1'b1), .d1(1'b0), .y(not_d));

    // mux_in[3] = c | (~c & ~d) = mux(c, not_d, 1)
    mux2to1 mux3 (.sel(c), .d0(not_d), .d1(1'b1), .y(mux_in[3]));

endmodule