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
    wire mux0, mux2, mux3;

    // mux_in[0] (ab=00):
    // c=0 -> output = d
    // c=1 -> output = 1
    mux2to1 mux0_mux (.sel(c), .d0(d), .d1(1'b1), .y(mux0));

    // mux_in[1] (ab=01): constant 0
    wire mux1 = 1'b0;

    // mux_in[2] (ab=11):
    // c=0 -> 0
    // c=1 -> d
    mux2to1 mux2_mux (.sel(c), .d0(1'b0), .d1(d), .y(mux2));

    // mux_in[3] (ab=10):
    // c=0 -> ~d
    // c=1 -> 1
    mux2to1 mux3_mux (.sel(c), .d0(~d), .d1(1'b1), .y(mux3));

    assign mux_in = {mux3, mux2, mux1, mux0};
endmodule