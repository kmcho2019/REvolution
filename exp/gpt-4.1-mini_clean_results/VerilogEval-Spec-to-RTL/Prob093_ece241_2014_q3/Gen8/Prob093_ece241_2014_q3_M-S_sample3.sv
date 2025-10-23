// 2-to-1 multiplexer
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
    wire low, high;

    // mux_in[0] for ab=00: cd=00:0, 01:1, 11:1, 10:1
    // low: c=0 selects between cd=00 (0) and cd=01 (1)
    // high: c=1 selects between cd=10 (1) and cd=11 (1)
    wire in0_low, in0_high;
    mux2 mux0_low  (.sel(c), .in0(1'b0), .in1(1'b1), .out(in0_low));
    mux2 mux0_high (.sel(c), .in0(1'b1), .in1(1'b1), .out(in0_high));
    mux2 mux0_top  (.sel(d), .in0(in0_low), .in1(in0_high), .out(mux_in[0]));

    // mux_in[1] for ab=01: all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: cd=00:0, 01:0, 11:1, 10:0
    // low: c=0 between cd=00 (0) and cd=01 (0)
    // high: c=1 between cd=10 (0) and cd=11 (1)
    wire in2_low, in2_high;
    mux2 mux2_low  (.sel(c), .in0(1'b0), .in1(1'b0), .out(in2_low));
    mux2 mux2_high (.sel(c), .in0(1'b0), .in1(1'b1), .out(in2_high));
    mux2 mux2_top  (.sel(d), .in0(in2_low), .in1(in2_high), .out(mux_in[2]));

    // mux_in[3] for ab=10: cd=00:1, 01:0, 11:1, 10:1
    // low: c=0 between cd=00 (1) and cd=01 (0)
    // high: c=1 between cd=10 (1) and cd=11 (1)
    wire in3_low, in3_high;
    mux2 mux3_low  (.sel(c), .in0(1'b1), .in1(1'b0), .out(in3_low));
    mux2 mux3_high (.sel(c), .in0(1'b1), .in1(1'b1), .out(in3_high));
    mux2 mux3_top  (.sel(d), .in0(in3_low), .in1(in3_high), .out(mux_in[3]));

endmodule