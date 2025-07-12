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

    // mux_in[0] corresponds to ab=00 column of K-map:
    // cd: 00->0, 01->1, 11->1, 10->1
    // Express as mux on c, selecting between:
    // c=0: d=0->0, d=1->1
    // c=1: d=0->1, d=1->1
    // So mux0_c0 = mux2to1(d,0,1)
    // mux0_c1 = 1 (constant)
    // mux0 = mux2to1(c, mux0_c0, 1)
    wire mux0_c0, mux0;
    mux2to1 mux0_d (.sel(d), .d0(1'b0), .d1(1'b1), .y(mux0_c0));
    mux2to1 mux0_c (.sel(c), .d0(mux0_c0), .d1(1'b1), .y(mux0));

    // mux_in[1] corresponds to ab=01 column of K-map:
    // all zeros (constant 0)
    wire mux1 = 1'b0;

    // mux_in[2] corresponds to ab=11 column of K-map:
    // cd: 00->0, 01->0, 11->1, 10->0
    // For c=0: always 0
    // For c=1: d=0->0, d=1->1
    // mux2_c0 = 0
    // mux2_c1 = d
    // mux2 = mux2to1(c, 0, d)
    wire mux2;
    mux2to1 mux2_c (.sel(c), .d0(1'b0), .d1(d), .y(mux2));

    // mux_in[3] corresponds to ab=10 column of K-map:
    // cd: 00->1, 01->0, 11->1, 10->1
    // For c=0: d=0->1, d=1->0
    // For c=1: always 1
    // mux3_c0 = mux2to1(d,1,0)
    // mux3_c1 = 1
    // mux3 = mux2to1(c, mux3_c0, 1)
    wire mux3_c0, mux3;
    mux2to1 mux3_d (.sel(d), .d0(1'b1), .d1(1'b0), .y(mux3_c0));
    mux2to1 mux3_c (.sel(c), .d0(mux3_c0), .d1(1'b1), .y(mux3));

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule