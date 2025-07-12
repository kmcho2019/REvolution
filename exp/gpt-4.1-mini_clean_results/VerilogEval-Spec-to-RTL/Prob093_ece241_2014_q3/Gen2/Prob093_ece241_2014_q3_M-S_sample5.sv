module mux2to1(
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
    // mux_in[0], ab=00 column: cd=00->0,01->1,11->1,10->1
    // Index cd as c d: 
    // c=0: d=0->0, d=1->1
    // c=1: d=0->1, d=1->1
    wire mux0_c0, mux0_c1;
    mux2to1 mux0_d0 (.sel(d), .in0(1'b0), .in1(1'b1), .out(mux0_c0));
    mux2to1 mux0_d1 (.sel(d), .in0(1'b1), .in1(1'b1), .out(mux0_c1));
    mux2to1 mux0_c  (.sel(c), .in0(mux0_c0), .in1(mux0_c1), .out(mux_in[0]));

    // mux_in[1], ab=01 column: all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2], ab=11 column: cd=00->0,01->0,11->1,10->0
    // c=0: d=0->0, d=1->0
    // c=1: d=0->0, d=1->1
    wire mux2_c0, mux2_c1;
    mux2to1 mux2_d0 (.sel(d), .in0(1'b0), .in1(1'b0), .out(mux2_c0));
    mux2to1 mux2_d1 (.sel(d), .in0(1'b0), .in1(1'b1), .out(mux2_c1));
    mux2to1 mux2_c  (.sel(c), .in0(mux2_c0), .in1(mux2_c1), .out(mux_in[2]));

    // mux_in[3], ab=10 column: cd=00->1,01->0,11->1,10->1
    // c=0: d=0->1, d=1->0
    // c=1: d=0->1, d=1->1
    wire mux3_c0, mux3_c1;
    mux2to1 mux3_d0 (.sel(d), .in0(1'b1), .in1(1'b0), .out(mux3_c0));
    mux2to1 mux3_d1 (.sel(d), .in0(1'b1), .in1(1'b1), .out(mux3_c1));
    mux2to1 mux3_c  (.sel(c), .in0(mux3_c0), .in1(mux3_c1), .out(mux_in[3]));

endmodule