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
    // mux_in[0] for ab=00: 0 0 0 1 at cd=00,01,11,10
    // c=0: always 0 (d=0->0, d=1->0)
    // c=1: d=0->1, d=1->0
    wire mux0_d_out;
    mux2 mux0_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(mux0_d_out));
    wire mux0;
    mux2 mux0_c (.sel(c), .in0(1'b0), .in1(mux0_d_out), .out(mux0));

    // mux_in[1] for ab=01: all zeros
    wire mux1 = 1'b0;

    // mux_in[2] for ab=11: 0 0 1 0 at cd=00,01,11,10
    // c=0: d=0->0, d=1->0
    // c=1: d=0->0, d=1->1
    wire mux2_d_out;
    mux2 mux2_d (.sel(d), .in0(1'b0), .in1(1'b1), .out(mux2_d_out));
    wire mux2;
    mux2 mux2_c (.sel(c), .in0(1'b0), .in1(mux2_d_out), .out(mux2));

    // mux_in[3] for ab=10: 1 0 1 1 at cd=00,01,11,10
    // c=0: d=0->1, d=1->0
    // c=1: always 1
    wire mux3_d_out;
    mux2 mux3_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(mux3_d_out));
    wire mux3;
    mux2 mux3_c (.sel(c), .in0(mux3_d_out), .in1(1'b1), .out(mux3));

    assign mux_in = {mux3, mux2, mux1, mux0};
endmodule