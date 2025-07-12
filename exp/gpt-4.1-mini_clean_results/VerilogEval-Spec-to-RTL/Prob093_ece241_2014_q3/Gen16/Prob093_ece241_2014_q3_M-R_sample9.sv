module mux2to1 (
    input  in0,
    input  in1,
    input  sel,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // For each mux_in[i], implement F(c,d) from K-map row at ab=i

    // mux_in[0]: ab=00
    // cd: 00=0, 01=0, 11=0, 10=1
    // Let's reorder cd as d=0 or 1:
    // c=0,d=0:0, c=0,d=1:0
    // c=1,d=0:1, c=1,d=1:0
    // So at c=0: output = 0 (both d=0,1)
    // at c=1: output = d?0:1 -> when d=0 output=1 else 0 => output = ~d
    wire not_d0;
    mux2to1 not_d_0 ( .in0(1'b1), .in1(1'b0), .sel(d), .out(not_d0) );
    mux2to1 mux_in0_mux ( .in0(1'b0), .in1(not_d0), .sel(c), .out(mux_in[0]) );

    // mux_in[1]: ab=01
    // cd: 00=1, 01=0, 11=0, 10=0
    // c=0,d=0:1, c=0,d=1:0
    // c=1,d=0:0, c=1,d=1:0
    // at c=0: output = d?0:1 = ~d
    // at c=1: output = 0
    wire not_d1;
    mux2to1 not_d_1 ( .in0(1'b1), .in1(1'b0), .sel(d), .out(not_d1) );
    mux2to1 mux_in1_mux ( .in0(not_d1), .in1(1'b0), .sel(c), .out(mux_in[1]) );

    // mux_in[2]: ab=11
    // cd: 00=0, 01=0, 11=1, 10=0
    // c=0,d=0:0, c=0,d=1:0
    // c=1,d=0:0, c=1,d=1:1
    // at c=0: output=0 (both d=0,1)
    // at c=1: output=d
    mux2to1 mux_in2_mux ( .in0(1'b0), .in1(d), .sel(c), .out(mux_in[2]) );

    // mux_in[3]: ab=10
    // cd: 00=1, 01=0, 11=1, 10=1
    // c=0,d=0:1, c=0,d=1:0
    // c=1,d=0:1, c=1,d=1:1
    // at c=0: output=~d
    // at c=1: output=1
    wire not_d3;
    mux2to1 not_d_3 ( .in0(1'b1), .in1(1'b0), .sel(d), .out(not_d3) );
    mux2to1 mux_in3_mux ( .in0(not_d3), .in1(1'b1), .sel(c), .out(mux_in[3]) );

endmodule