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

    // mux_in[0] = c OR d = c ? 1 : d
    wire mux0;
    mux2to1 mux0_inst (.sel(c), .d0(d), .d1(1'b1), .y(mux0));

    // mux_in[1] = 0
    wire mux1 = 1'b0;

    // mux_in[2] = c AND d = c ? d : 0
    wire mux2;
    mux2to1 mux2_inst (.sel(c), .d0(1'b0), .d1(d), .y(mux2));

    // mux_in[3] = c ? 1 : ~d
    wire not_d;
    mux2to1 notd_mux (.sel(d), .d0(1'b1), .d1(1'b0), .y(not_d)); // ~d = mux with d selector between 1 and 0
    wire mux3;
    mux2to1 mux3_inst (.sel(c), .d0(not_d), .d1(1'b1), .y(mux3));

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule