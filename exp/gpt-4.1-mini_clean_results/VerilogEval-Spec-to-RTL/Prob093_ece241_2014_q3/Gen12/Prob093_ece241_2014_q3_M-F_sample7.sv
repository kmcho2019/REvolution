module mux2to1 (
    input  sel,
    input  d0,
    input  d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0]: ab=00 column (00)
    // Output = c OR d
    wire mux0;
    mux2to1 mux0_inst (.sel(c), .d0(d), .d1(1'b1), .y(mux0));

    // mux_in[1]: ab=01 column (01)
    // All zeros
    wire mux1 = 1'b0;

    // mux_in[2]: ab=10 column (10)
    // Output = c + ~d
    // ~d = mux2to1(sel=d, d0=1, d1=0)
    wire not_d;
    mux2to1 notd_mux (.sel(d), .d0(1'b1), .d1(1'b0), .y(not_d));
    wire mux2;
    mux2to1 mux2_inst (.sel(c), .d0(not_d), .d1(1'b1), .y(mux2));

    // mux_in[3]: ab=11 column (11)
    // Output = c & d = mux2to1(sel=c, d0=0, d1=d)
    wire mux3;
    mux2to1 mux3_inst (.sel(c), .d0(1'b0), .d1(d), .y(mux3));

    // Assign mux_in outputs in standard order:
    // mux_in[0] = ab=00
    // mux_in[1] = ab=01
    // mux_in[2] = ab=10
    // mux_in[3] = ab=11
    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule