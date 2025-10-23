module mux2to1 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // For mux_in[0] (ab=00)
    // From K-map:
    // cd=00->0
    // cd=01->1
    // cd=11->1
    // cd=10->1
    // So:
    // when c=0: d=0->0, d=1->1
    // when c=1: always 1
    wire d_mux0_0; // output when c=0 and d select
    mux2to1 d_mux0 (.sel(d), .in0(1'b0), .in1(1'b1), .out(d_mux0_0));
    mux2to1 c_mux0 (.sel(c), .in0(d_mux0_0), .in1(1'b1), .out(mux_in[0]));

    // For mux_in[1] (ab=01)
    // Always 0
    assign mux_in[1] = 1'b0;

    // For mux_in[2] (ab=11)
    // cd=00->0
    // cd=01->0
    // cd=11->1
    // cd=10->0
    // So:
    // when c=0: always 0
    // when c=1: d=0->0, d=1->1
    wire d_mux2_1; // output when c=1 and d select
    mux2to1 d_mux2 (.sel(d), .in0(1'b0), .in1(1'b1), .out(d_mux2_1));
    mux2to1 c_mux2 (.sel(c), .in0(1'b0), .in1(d_mux2_1), .out(mux_in[2]));

    // For mux_in[3] (ab=10)
    // cd=00->1
    // cd=01->0
    // cd=11->1
    // cd=10->1
    // So:
    // when c=0: d=0->1, d=1->0
    // when c=1: always 1
    wire d_mux3_0;
    mux2to1 d_mux3 (.sel(d), .in0(1'b1), .in1(1'b0), .out(d_mux3_0));
    mux2to1 c_mux3 (.sel(c), .in0(d_mux3_0), .in1(1'b1), .out(mux_in[3]));

endmodule