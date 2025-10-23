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

    // mux_in[0] for ab=00: cd = 00:0, 01:1, 11:1, 10:1
    // c=0 => d=0->0, d=1->1
    // c=1 => 1
    wire mux0_c0;
    mux2 mux0_d(.sel(d), .in0(1'b0), .in1(1'b1), .out(mux0_c0));
    wire mux0_c1 = 1'b1;
    wire mux0;
    mux2 mux0_c(.sel(c), .in0(mux0_c0), .in1(mux0_c1), .out(mux0));

    // mux_in[1] for ab=01: all zeros
    wire mux1 = 1'b0;

    // mux_in[2] for ab=11: cd=00:0,01:0,11:1,10:0
    // c=0 => 0
    // c=1 => d=0->0, d=1->1
    wire mux2_c1_d;
    mux2 mux2_d(.sel(d), .in0(1'b0), .in1(1'b1), .out(mux2_c1_d));
    wire mux2_c0 = 1'b0;
    wire mux2;
    mux2 mux2_c(.sel(c), .in0(mux2_c0), .in1(mux2_c1_d), .out(mux2));

    // mux_in[3] for ab=10: cd=00:1,01:0,11:1,10:1
    // c=0 => d=0->1, d=1->0
    // c=1 => 1
    wire mux3_c0_d;
    mux2 mux3_d(.sel(d), .in0(1'b1), .in1(1'b0), .out(mux3_c0_d));
    wire mux3_c1 = 1'b1;
    wire mux3;
    mux2 mux3_c(.sel(c), .in0(mux3_c0_d), .in1(mux3_c1), .out(mux3));

    // Assign mux_in[3:0] in order: mux_in[0]=ab=00, mux_in[1]=ab=01, mux_in[2]=ab=11, mux_in[3]=ab=10
    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule