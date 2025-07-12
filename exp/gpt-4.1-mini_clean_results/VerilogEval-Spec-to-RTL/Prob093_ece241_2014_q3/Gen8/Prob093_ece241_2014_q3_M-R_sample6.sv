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
    // For each mux_in[i], define output as per K-map (c,d inputs):

    // mux_in[0] (ab=00): cd:00->0,01->1,11->1,10->1
    // c=0,d=0->0; c=0,d=1->1; c=1,d=0->1; c=1,d=1->1
    wire mux0_d = mux_in[0]_d; // intermediate mux selecting d=0 or d=1 for c=0
    wire mux0_d1 = 1'b1;        // c=1,d=1 = 1
    wire mux0_d0 = mux_in[0]_d0; 

    mux2to1 mux0_d0mux (.sel(d), .d0(1'b0), .d1(1'b1), .y(mux0_d0)); // c=0, select d=0 or 1
    // For c=1, d=0 or 1 -> always 1
    mux2to1 mux0_c (.sel(c), .d0(mux0_d0), .d1(1'b1), .y(mux_in[0]));

    // mux_in[1] (ab=01): cd: all 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): cd:00->0,01->0,11->1,10->0
    // c=0,d=0->0; c=0,d=1->0; c=1,d=0->0; c=1,d=1->1
    wire mux2_d;
    mux2to1 mux2_dmux (.sel(d), .d0(1'b0), .d1(1'b0), .y(mux2_d)); // c=0 branch: always 0
    wire mux2_d_c1;
    mux2to1 mux2_d_c1mux (.sel(d), .d0(1'b0), .d1(1'b1), .y(mux2_d_c1)); // c=1 branch
    mux2to1 mux2_c (.sel(c), .d0(mux2_d), .d1(mux2_d_c1), .y(mux_in[2]));

    // mux_in[3] (ab=10): cd:00->1,01->0,11->1,10->1
    // c=0,d=0->1; c=0,d=1->0; c=1,d=0->1; c=1,d=1->1
    wire mux3_d_c0;
    mux2to1 mux3_d_c0mux (.sel(d), .d0(1'b1), .d1(1'b0), .y(mux3_d_c0)); // c=0 branch
    wire mux3_d_c1;
    mux2to1 mux3_d_c1mux (.sel(d), .d0(1'b1), .d1(1'b1), .y(mux3_d_c1)); // c=1 branch always 1
    mux2to1 mux3_c (.sel(c), .d0(mux3_d_c0), .d1(mux3_d_c1), .y(mux_in[3]));

endmodule