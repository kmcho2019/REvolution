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

    // mux_in[0]: For ab=00
    // K-map: cd=00->0, 01->1, 11->1, 10->1
    // When c=0, output=d; when c=1 output=1
    wire mux0_c0;
    mux2to1 mux0_d (.sel(d), .d0(1'b0), .d1(1'b1), .y(mux0_c0)); // d selects between 0 and 1 for c=0
    wire mux0;
    mux2to1 mux0_c (.sel(c), .d0(mux0_c0), .d1(1'b1), .y(mux0)); // c selects between mux0_c0 and 1

    // mux_in[1]: For ab=01
    // K-map column all zeros
    wire mux1 = 1'b0;

    // mux_in[2]: For ab=11
    // K-map: cd=00->0, 01->0, 11->1, 10->0
    // When c=0 output=0; when c=1 output=d
    wire mux2;
    mux2to1 mux2_c (.sel(c), .d0(1'b0), .d1(d), .y(mux2));

    // mux_in[3]: For ab=10
    // K-map: cd=00->1, 01->0, 11->1, 10->1
    // When c=0: output = ~d (d=0->1, d=1->0)
    // When c=1: output=1
    wire mux3_c0;
    mux2to1 mux3_d (.sel(d), .d0(1'b1), .d1(1'b0), .y(mux3_c0)); // d selects between 1 and 0 when c=0
    wire mux3;
    mux2to1 mux3_c (.sel(c), .d0(mux3_c0), .d1(1'b1), .y(mux3)); // c selects between mux3_c0 and 1

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule