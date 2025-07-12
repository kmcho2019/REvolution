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

    // mux_in[0] for ab=00: cd→0 1 1 1 at cd=00,01,11,10
    // Implement as mux2 with c select:
    // c=0 (cd=00 or 01): outputs depend on d: d=0→0, d=1→1
    // c=1 (cd=11 or 10): both outputs 1
    wire mux0_c0, mux0_c1;
    mux2 mux0_d (.sel(d), .in0(1'b0), .in1(1'b1), .out(mux0_c0));
    assign mux0_c1 = 1'b1;
    wire mux0;
    mux2 mux0_c (.sel(c), .in0(mux0_c0), .in1(mux0_c1), .out(mux0));

    // mux_in[1] for ab=01: all zeros
    wire mux1 = 1'b0;

    // mux_in[2] for ab=11: cd→0 0 1 0 at cd=00,01,11,10
    // c=0 (cd=00,01): both 0
    // c=1 (cd=11,10): d=0->0, d=1->1 (cd=10=0, cd=11=1)
    wire mux2_c0 = 1'b0;
    wire mux2_c1;
    mux2 mux2_d (.sel(d), .in0(1'b0), .in1(1'b1), .out(mux2_c1));
    wire mux2_out;
    mux2 mux2_c (.sel(c), .in0(mux2_c0), .in1(mux2_c1), .out(mux2_out));

    // mux_in[3] for ab=10: cd→1 0 1 1 at cd=00,01,11,10
    // c=0 (cd=00,01): d=0->1, d=1->0
    // c=1 (cd=11,10): both 1
    wire mux3_c0;
    mux2 mux3_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(mux3_c0));
    wire mux3_c1 = 1'b1;
    wire mux3_out;
    mux2 mux3_c (.sel(c), .in0(mux3_c0), .in1(mux3_c1), .out(mux3_out));

    assign mux_in = {mux3_out, mux2_out, mux1, mux0};

endmodule