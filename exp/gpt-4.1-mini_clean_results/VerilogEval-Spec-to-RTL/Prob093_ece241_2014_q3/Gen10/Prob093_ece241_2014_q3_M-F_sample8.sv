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

    // mux_in[0]: ab=00 column of K-map
    // For c=0 output=d, for c=1 output=1
    wire mux0;
    mux2to1 mux0_inst (.sel(c), .d0(d), .d1(1'b1), .y(mux0));

    // mux_in[1]: ab=01 column all zeros
    wire mux1 = 1'b0;

    // mux_in[2]: ab=11 column of K-map
    // For c=0 output=0, for c=1 output=d
    wire mux2;
    mux2to1 mux2_inst (.sel(c), .d0(1'b0), .d1(d), .y(mux2));

    // mux_in[3]: ab=10 column of K-map
    // For c=0 output=~d, for c=1 output=1
    wire not_d;
    mux2to1 notd_mux (.sel(d), .d0(1'b1), .d1(1'b0), .y(not_d)); // ~d = (d=0->1, d=1->0)
    wire mux3;
    mux2to1 mux3_inst (.sel(c), .d0(not_d), .d1(1'b1), .y(mux3));

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule