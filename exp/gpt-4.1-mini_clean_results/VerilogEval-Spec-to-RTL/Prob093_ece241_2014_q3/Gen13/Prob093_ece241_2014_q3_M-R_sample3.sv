module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // ab=00 -> mux_in[0] from K-map column: cd = 00:0,01:1,11:1,10:1
    // Implement as mux2(c) with:
    // c=0: mux2(d,0,1)
    // c=1: 1
    wire mux0_c0, mux0;
    mux2 mux0_d(.sel(d), .in0(1'b0), .in1(1'b1), .out(mux0_c0));
    mux2 mux0_c(.sel(c), .in0(mux0_c0), .in1(1'b1), .out(mux0));

    // ab=01 -> mux_in[1]: all zeros
    wire mux1 = 1'b0;

    // ab=11 -> mux_in[2]: cd = 00:0,01:0,11:1,10:0
    // c=0: 0
    // c=1: mux2(d,0,1)
    wire mux2_c1_d, mux2;
    mux2 mux2_d(.sel(d), .in0(1'b0), .in1(1'b1), .out(mux2_c1_d));
    mux2 mux2_c(.sel(c), .in0(1'b0), .in1(mux2_c1_d), .out(mux2));

    // ab=10 -> mux_in[3]: cd = 00:1,01:0,11:1,10:1
    // c=0: mux2(d,1,0)
    // c=1: 1
    wire mux3_c0_d, mux3;
    mux2 mux3_d(.sel(d), .in0(1'b1), .in1(1'b0), .out(mux3_c0_d));
    mux2 mux3_c(.sel(c), .in0(mux3_c0_d), .in1(1'b1), .out(mux3));

    // Assign mux_in bits in order for the external 4-to-1 mux selector {a,b}:
    // mux_in[0] = ab=00
    // mux_in[1] = ab=01
    // mux_in[2] = ab=11
    // mux_in[3] = ab=10
    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule