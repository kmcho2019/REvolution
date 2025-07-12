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

    // Helper function to build each mux_in bit as:
    // mux_in[i] = mux2to1(c,
    //                     mux2to1(d, val_i00, val_i01),
    //                     mux2to1(d, val_i10, val_i11));
    //
    // Where val_iXY = output for ab=i, c=X, d=Y from the K-map column ab=i.

    // K-map given (rows=cd, cols=ab):
    //      ab
    // cd  00 01 11 10
    // 00 |0 |0 |0 |1 |
    // 01 |1 |0 |0 |0 |
    // 11 |1 |0 |1 |1 |
    // 10 |1 |0 |0 |1 |
    //
    // For ab=00 (mux_in[0]):
    // c=0,d=0 -> 0 (row cd=00)
    // c=0,d=1 -> 1 (row cd=01)
    // c=1,d=1 -> 1 (row cd=11)
    // c=1,d=0 -> 1 (row cd=10)
    //
    // For ab=01 (mux_in[1]):
    // all zeros
    //
    // For ab=11 (mux_in[2]):
    // c=0,d=0 ->0
    // c=0,d=1 ->0
    // c=1,d=1 ->1
    // c=1,d=0 ->0
    //
    // For ab=10 (mux_in[3]):
    // c=0,d=0 ->1
    // c=0,d=1 ->0
    // c=1,d=1 ->1
    // c=1,d=0 ->1

    wire m0_d0, m0_d1, m0_c;
    mux2to1 m0_d (.sel(d), .d0(1'b0), .d1(1'b1), .y(m0_d0)); // c=0 case: d=0->0, d=1->1
    wire m0_d_branch;
    mux2to1 m0_d1mux (.sel(d), .d0(1'b1), .d1(1'b1), .y(m0_d1)); // c=1 case: both d=0 and d=1 ->1
    mux2to1 m0_cmux (.sel(c), .d0(m0_d0), .d1(m0_d1), .y(m0_c));

    wire m1_d0, m1_d1, m1_c;
    // all zeros
    mux2to1 m1_d_mux0 (.sel(d), .d0(1'b0), .d1(1'b0), .y(m1_d0));
    mux2to1 m1_d_mux1 (.sel(d), .d0(1'b0), .d1(1'b0), .y(m1_d1));
    mux2to1 m1_cmux (.sel(c), .d0(m1_d0), .d1(m1_d1), .y(m1_c));

    wire m2_d0, m2_d1, m2_c;
    mux2to1 m2_d_mux0 (.sel(d), .d0(1'b0), .d1(1'b0), .y(m2_d0)); // c=0: d=0->0, d=1->0
    mux2to1 m2_d_mux1 (.sel(d), .d0(1'b0), .d1(1'b1), .y(m2_d1)); // c=1: d=0->0, d=1->1
    mux2to1 m2_cmux (.sel(c), .d0(m2_d0), .d1(m2_d1), .y(m2_c));

    wire m3_d0, m3_d1, m3_c;
    mux2to1 m3_d_mux0 (.sel(d), .d0(1'b1), .d1(1'b0), .y(m3_d0)); // c=0: d=0->1, d=1->0
    mux2to1 m3_d_mux1 (.sel(d), .d0(1'b1), .d1(1'b1), .y(m3_d1)); // c=1: d=0->1, d=1->1
    mux2to1 m3_cmux (.sel(c), .d0(m3_d0), .d1(m3_d1), .y(m3_c));

    // Assign mux_in in order mux_in[0]=ab=00,..., mux_in[3]=ab=10
    assign mux_in = {m3_c, m2_c, m1_c, m0_c};

endmodule