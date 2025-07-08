module mux2(input sel, input d0, input d1, output y);
    assign y = sel ? d1 : d0;
endmodule

module TopModule(input c, input d, output [3:0] mux_in);
    // Implement mux_in[0] for ab=00
    // Values for c d: 00->0, 01->1, 11->1, 10->1
    // Let's build the function using muxes:
    // For d=0: c=0->0, c=1->1
    // For d=1: c=0->1, c=1->1
    // So mux_in[0] = mux2 d (c) (1)
    wire mux_in0_d0; // c when d=0
    mux2 m0_0(.sel(c), .d0(1'b0), .d1(1'b1), .y(mux_in0_d0));
    // When d=1, output is always 1
    // mux_in0 = mux2 d (mux_in0_d0) (1)
    mux2 m0_1(.sel(d), .d0(mux_in0_d0), .d1(1'b1), .y(mux_in[0]));

    // Implement mux_in[1] for ab=01
    // Values for c d: all 0
    assign mux_in[1] = 1'b0;

    // Implement mux_in[2] for ab=11
    // Values for c d: 00->0,01->0,11->1,10->0
    // For d=0: c=0->0, c=1->0
    // For d=1: c=0->0, c=1->1
    // So mux_in[2] = mux2 d (0) (mux2 c (0) (1))
    wire mux_in2_d1;
    mux2 m2_0(.sel(c), .d0(1'b0), .d1(1'b1), .y(mux_in2_d1));
    mux2 m2_1(.sel(d), .d0(1'b0), .d1(mux_in2_d1), .y(mux_in[2]));

    // Implement mux_in[3] for ab=10
    // Values for c d: 00->1, 01->0, 11->1, 10->1
    // For d=0: c=0->1, c=1->1
    // For d=1: c=0->0, c=1->1
    // For d=0 output is 1
    // For d=1 output is mux2 c 0 1
    wire mux_in3_d1;
    mux2 m3_0(.sel(c), .d0(1'b0), .d1(1'b1), .y(mux_in3_d1));
    mux2 m3_1(.sel(d), .d0(1'b1), .d1(mux_in3_d1), .y(mux_in[3]));

endmodule