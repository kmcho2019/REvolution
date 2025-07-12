module mux2to1 (
    input sel,
    input d0,
    input d1,
    output y
);
    // 2-to-1 multiplexer: if sel=0 output d0 else d1
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    // For each mux_in bit, build the 4-valued function (cd=00,01,11,10) using only 2-to-1 muxes and constants

    // K-map columns for ab=00,01,11,10:
    // row order cd=00,01,11,10
    // mux_in[0] (ab=00): 0,1,1,1
    // mux_in[1] (ab=01): 0,0,0,0
    // mux_in[2] (ab=11): 0,0,1,0
    // mux_in[3] (ab=10): 1,0,1,1

    // Build each mux_in[i]:

    // Helper wires for intermediate muxes

    // mux_in[0] steps:
    // M1 = mux(d, 0 (cd=00), 1 (cd=01))
    wire m0_lower;
    mux2to1 m0_m1(.sel(d), .d0(1'b0), .d1(1'b1), .y(m0_lower));

    // M2 = mux(d, 1 (cd=11), 1 (cd=10))
    wire m0_upper;
    mux2to1 m0_m2(.sel(d), .d0(1'b1), .d1(1'b1), .y(m0_upper));

    // Final mux with c: mux(c, m0_lower, m0_upper)
    mux2to1 m0_m3(.sel(c), .d0(m0_lower), .d1(m0_upper), .y(mux_in[0]));


    // mux_in[1] steps (all zeros)
    // Just assign zero directly
    assign mux_in[1] = 1'b0;


    // mux_in[2] steps:
    // M1 = mux(d, 0, 0)
    wire m2_lower;
    mux2to1 m2_m1(.sel(d), .d0(1'b0), .d1(1'b0), .y(m2_lower));

    // M2 = mux(d, 1, 0)
    wire m2_upper;
    mux2to1 m2_m2(.sel(d), .d0(1'b1), .d1(1'b0), .y(m2_upper));

    // Final mux with c: mux(c, m2_lower, m2_upper)
    mux2to1 m2_m3(.sel(c), .d0(m2_lower), .d1(m2_upper), .y(mux_in[2]));


    // mux_in[3] steps:
    // M1 = mux(d, 1, 0)
    wire m3_lower;
    mux2to1 m3_m1(.sel(d), .d0(1'b1), .d1(1'b0), .y(m3_lower));

    // M2 = mux(d, 1, 1)
    wire m3_upper;
    mux2to1 m3_m2(.sel(d), .d0(1'b1), .d1(1'b1), .y(m3_upper));

    // Final mux with c: mux(c, m3_lower, m3_upper)
    mux2to1 m3_m3(.sel(c), .d0(m3_lower), .d1(m3_upper), .y(mux_in[3]));

endmodule