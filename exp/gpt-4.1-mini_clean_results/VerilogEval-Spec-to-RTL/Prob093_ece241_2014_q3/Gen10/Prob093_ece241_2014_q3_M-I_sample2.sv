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

    // --- mux_in[0] for ab=00 column ---
    // K-map column ab=00:
    // cd=00(0,0):0
    // cd=01(0,1):1
    // cd=11(1,1):1
    // cd=10(1,0):1
    //
    // Function f_00(c,d):
    // When c=0: d=0->0, d=1->1  -> mux on d: d=0->0, d=1->1
    // When c=1: always 1
    // Implement:
    // wire mux0_c0 = mux2to1(d,0,1);
    // mux_in[0] = mux2to1(c, mux0_c0, 1);
    wire mux0_c0;
    mux2to1 mux0_d (.sel(d), .d0(1'b0), .d1(1'b1), .y(mux0_c0));
    wire mux0;
    mux2to1 mux0_c (.sel(c), .d0(mux0_c0), .d1(1'b1), .y(mux0));

    // --- mux_in[1] for ab=01 column ---
    // all zeros
    wire mux1 = 1'b0;

    // --- mux_in[2] for ab=11 column ---
    // cd=00:0
    // cd=01:0
    // cd=11:1
    // cd=10:0
    //
    // For c=0: all 0 (d=0->0, d=1->0)
    // For c=1: d=0->0, d=1->1
    // Implement:
    // mux2_c0 = 0;
    // mux2_c1 = d;
    // mux_in[2] = mux2to1(c, 0, d);
    wire mux2;
    mux2to1 mux2_c (.sel(c), .d0(1'b0), .d1(d), .y(mux2));

    // --- mux_in[3] for ab=10 column ---
    // cd=00:1
    // cd=01:0
    // cd=11:1
    // cd=10:1
    //
    // For c=0: d=0->1, d=1->0
    // For c=1: always 1
    // Implement:
    // mux3_c0 = mux2to1(d,1,0);
    // mux3_c1 = 1;
    // mux_in[3] = mux2to1(c, mux3_c0, 1);
    wire mux3_c0;
    mux2to1 mux3_d (.sel(d), .d0(1'b1), .d1(1'b0), .y(mux3_c0));
    wire mux3;
    mux2to1 mux3_c (.sel(c), .d0(mux3_c0), .d1(1'b1), .y(mux3));

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule