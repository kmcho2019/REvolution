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
    // mux_in[0] for ab=00: cd=00(0),01(1),11(1),10(1)
    wire mux0_low, mux0_high;
    mux2 mux0_low_mux  (.sel(c), .in0(1'b0), .in1(1'b1), .out(mux0_low));
    mux2 mux0_high_mux (.sel(c), .in0(1'b1), .in1(1'b1), .out(mux0_high));
    mux2 mux0_top_mux  (.sel(d), .in0(mux0_low), .in1(mux0_high), .out(mux_in[0]));

    // mux_in[1] for ab=01: all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2] for ab=11: cd=00(0),01(0),11(1),10(0)
    wire mux2_low, mux2_high;
    mux2 mux2_low_mux  (.sel(c), .in0(1'b0), .in1(1'b0), .out(mux2_low));
    mux2 mux2_high_mux (.sel(c), .in0(1'b0), .in1(1'b1), .out(mux2_high));
    mux2 mux2_top_mux  (.sel(d), .in0(mux2_low), .in1(mux2_high), .out(mux_in[2]));

    // mux_in[3] for ab=10: cd=00(1),01(0),11(1),10(1)
    wire mux3_low, mux3_high;
    mux2 mux3_low_mux  (.sel(c), .in0(1'b1), .in1(1'b0), .out(mux3_low));
    mux2 mux3_high_mux (.sel(c), .in0(1'b1), .in1(1'b1), .out(mux3_high));
    mux2 mux3_top_mux  (.sel(d), .in0(mux3_low), .in1(mux3_high), .out(mux_in[3]));

endmodule