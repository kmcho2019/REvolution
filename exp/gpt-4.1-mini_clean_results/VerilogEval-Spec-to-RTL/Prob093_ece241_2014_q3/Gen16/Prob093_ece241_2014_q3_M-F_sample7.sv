module mux2 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    wire mux0_c0, mux0_c1, mux0_out;
    wire mux1_c0, mux1_c1, mux1_out;
    wire mux2_c0, mux2_c1, mux2_out;
    wire mux3_c0, mux3_c1, mux3_out;

    // ab=00 → mux_in[0]
    // cd=00=0, cd=01=0, cd=11=0, cd=10=1
    mux2 m0_d (.sel(d), .in0(1'b0), .in1(1'b0), .out(mux0_c0));
    mux2 m0_d1(.sel(d), .in0(1'b1), .in1(1'b0), .out(mux0_c1));
    mux2 m0_c (.sel(c), .in0(mux0_c0), .in1(mux0_c1), .out(mux0_out));

    // ab=01 → mux_in[1]
    // cd=00=1, cd=01=0, cd=11=0, cd=10=0
    mux2 m1_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(mux1_c0));
    mux2 m1_d1(.sel(d), .in0(1'b0), .in1(1'b0), .out(mux1_c1));
    mux2 m1_c (.sel(c), .in0(mux1_c0), .in1(mux1_c1), .out(mux1_out));

    // ab=11 → mux_in[2]
    // cd=00=0, cd=01=0, cd=11=1, cd=10=0
    mux2 m2_d (.sel(d), .in0(1'b0), .in1(1'b0), .out(mux2_c0));
    mux2 m2_d1(.sel(d), .in0(1'b0), .in1(1'b1), .out(mux2_c1));
    mux2 m2_c (.sel(c), .in0(mux2_c0), .in1(mux2_c1), .out(mux2_out));

    // ab=10 → mux_in[3]
    // cd=00=1, cd=01=0, cd=11=1, cd=10=1
    mux2 m3_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(mux3_c0));
    mux2 m3_d1(.sel(d), .in0(1'b1), .in1(1'b1), .out(mux3_c1));
    mux2 m3_c (.sel(c), .in0(mux3_c0), .in1(mux3_c1), .out(mux3_out));

    assign mux_in = {mux3_out, mux2_out, mux1_out, mux0_out};
endmodule