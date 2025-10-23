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
    // K-map columns correspond to ab values: 00, 01, 11, 10 mapped to mux_in[0], mux_in[1], mux_in[2], mux_in[3]
    // Each mux_in[i] is a function of c,d only, defined by the table in problem.

    // mux_in[0] for ab=00: cd=00->0,01->1,11->1,10->1
    wire m0_lower, m0_upper;
    mux2to1 mux0_0(.sel(d), .d0(1'b0), .d1(1'b1), .y(m0_lower));   // c=0: cd=00(0),01(1)
    mux2to1 mux0_1(.sel(d), .d0(1'b1), .d1(1'b1), .y(m0_upper));   // c=1: cd=11(1),10(1)
    mux2to1 mux0_2(.sel(c), .d0(m0_lower), .d1(m0_upper), .y(mux_in[0]));

    // mux_in[1] for ab=01: all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: cd=00->0,01->0,11->1,10->0
    wire m2_lower, m2_upper;
    mux2to1 mux2_0(.sel(d), .d0(1'b0), .d1(1'b0), .y(m2_lower));   // c=0: cd=00(0),01(0)
    mux2to1 mux2_1(.sel(d), .d0(1'b1), .d1(1'b0), .y(m2_upper));   // c=1: cd=11(1),10(0)
    mux2to1 mux2_2(.sel(c), .d0(m2_lower), .d1(m2_upper), .y(mux_in[2]));

    // mux_in[3] for ab=10: cd=00->1,01->0,11->1,10->1
    wire m3_lower, m3_upper;
    mux2to1 mux3_0(.sel(d), .d0(1'b1), .d1(1'b0), .y(m3_lower));   // c=0: cd=00(1),01(0)
    mux2to1 mux3_1(.sel(d), .d0(1'b1), .d1(1'b1), .y(m3_upper));   // c=1: cd=11(1),10(1)
    mux2to1 mux3_2(.sel(c), .d0(m3_lower), .d1(m3_upper), .y(mux_in[3]));
endmodule