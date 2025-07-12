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
    // K-map for each mux_in[i] (fixed ab, varying cd):
    // ab=00 -> mux_in[0]: cd=00->0,01->1,11->1,10->1
    // Implement mux_in[0]:
    // For c=0: d=0->0, d=1->1
    // For c=1: d=0->1, d=1->1
    wire m0_c0;
    mux2to1 mux0_c0 (.sel(d), .d0(1'b0), .d1(1'b1), .y(m0_c0));
    wire m0_c1;
    assign m0_c1 = 1'b1; // Both cd=10 and 11 are 1
    mux2to1 mux0 (.sel(c), .d0(m0_c0), .d1(m0_c1), .y(mux_in[0]));

    // ab=01 -> mux_in[1]: always 0
    assign mux_in[1] = 1'b0;

    // ab=11 -> mux_in[2]: cd=00->0,01->0,11->1,10->0
    // For c=0: d=0->0, d=1->0
    // For c=1: d=0->0, d=1->1
    wire m2_c0 = 1'b0;
    wire m2_c1;
    mux2to1 mux2_c1 (.sel(d), .d0(1'b0), .d1(1'b1), .y(m2_c1));
    mux2to1 mux2 (.sel(c), .d0(m2_c0), .d1(m2_c1), .y(mux_in[2]));

    // ab=10 -> mux_in[3]: cd=00->1,01->0,11->1,10->1
    // For c=0: d=0->1, d=1->0
    // For c=1: d=0->1, d=1->1
    wire m3_c0;
    mux2to1 mux3_c0 (.sel(d), .d0(1'b1), .d1(1'b0), .y(m3_c0));
    wire m3_c1;
    assign m3_c1 = 1'b1; // both d=0 and d=1 for c=1 are 1
    mux2to1 mux3 (.sel(c), .d0(m3_c0), .d1(m3_c1), .y(mux_in[3]));
endmodule