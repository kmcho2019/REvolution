module mux2to1 (
    input sel,
    input d0,
    input d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input a,
    input b,
    input c,
    input d,
    output [3:0] mux_in
);
    // K-map from the problem, for each column ab (0..3)
    // Rows cd=00,01,11,10
    // For ab=00 (mux_in[0]):
    // cd=00->0,01->1,11->1,10->1
    //
    // For ab=01 (mux_in[1]):
    // all 0
    //
    // For ab=11 (mux_in[2]):
    // cd=00->0,01->0,11->1,10->0
    //
    // For ab=10 (mux_in[3]):
    // cd=00->1,01->0,11->1,10->1

    // Build mux_in[0] = f_cd
    // Use d to select between pairs (cd=00 vs 01), and (cd=11 vs 10)
    wire m0_lower, m0_upper;
    mux2to1 mux0_0(.sel(d), .d0(1'b0), .d1(1'b1), .y(m0_lower));   // cd=00 or 01
    mux2to1 mux0_1(.sel(d), .d0(1'b1), .d1(1'b1), .y(m0_upper));   // cd=11 or 10
    mux2to1 mux0_2(.sel(c), .d0(m0_lower), .d1(m0_upper), .y(mux_in[0]));

    // mux_in[1]: all zeros for all cd
    assign mux_in[1] = 1'b0;

    // mux_in[2]:
    // cd=00->0, 01->0, 11->1, 10->0
    wire m2_lower, m2_upper;
    mux2to1 mux2_0(.sel(d), .d0(1'b0), .d1(1'b0), .y(m2_lower));   // cd=00 or 01
    mux2to1 mux2_1(.sel(d), .d0(1'b1), .d1(1'b0), .y(m2_upper));   // cd=11 or 10
    mux2to1 mux2_2(.sel(c), .d0(m2_lower), .d1(m2_upper), .y(mux_in[2]));

    // mux_in[3]:
    // cd=00->1, 01->0, 11->1, 10->1
    wire m3_lower, m3_upper;
    mux2to1 mux3_0(.sel(d), .d0(1'b1), .d1(1'b0), .y(m3_lower));   // cd=00 or 01
    mux2to1 mux3_1(.sel(d), .d0(1'b1), .d1(1'b1), .y(m3_upper));   // cd=11 or 10
    mux2to1 mux3_2(.sel(c), .d0(m3_lower), .d1(m3_upper), .y(mux_in[3]));
endmodule