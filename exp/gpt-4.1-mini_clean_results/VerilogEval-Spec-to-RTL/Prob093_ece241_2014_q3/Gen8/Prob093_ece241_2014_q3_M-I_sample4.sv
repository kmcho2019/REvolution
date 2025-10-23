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

    // mux_in[0] (ab=00):
    // For c=0: d=0->0, d=1->1
    // For c=1: always 1
    wire mux0_c0;
    mux2to1 mux0_d (.sel(d), .d0(1'b0), .d1(1'b1), .y(mux0_c0));
    wire mux0;
    mux2to1 mux0_c (.sel(c), .d0(mux0_c0), .d1(1'b1), .y(mux0));

    // mux_in[1] (ab=01): constant 0
    wire mux1 = 1'b0;

    // mux_in[2] (ab=11):
    // For c=0: always 0
    // For c=1: output = d
    wire mux2;
    mux2to1 mux2_c (.sel(c), .d0(1'b0), .d1(d), .y(mux2));

    // mux_in[3] (ab=10):
    // For c=0: d=0->1, d=1->0
    // For c=1: always 1
    wire mux3_c0;
    mux2to1 mux3_d (.sel(d), .d0(1'b1), .d1(1'b0), .y(mux3_c0));
    wire mux3;
    mux2to1 mux3_c (.sel(c), .d0(mux3_c0), .d1(1'b1), .y(mux3));

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule