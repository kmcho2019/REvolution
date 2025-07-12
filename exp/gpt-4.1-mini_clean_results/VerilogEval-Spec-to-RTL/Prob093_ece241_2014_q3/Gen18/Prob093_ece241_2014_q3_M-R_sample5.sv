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
    // Invert c and d
    wire not_c, not_d;
    mux2 inv_c (.sel(c),  .in0(1'b1), .in1(1'b0), .out(not_c));
    mux2 inv_d (.sel(d),  .in0(1'b1), .in1(1'b0), .out(not_d));

    // mux_in[0]: for ab=00 from K-map: cd=00(0),01(1),11(1),10(1)
    // Implement f0 = c OR d
    // f0 = c OR d = mux2(sel=c, in0=d, in1=1)
    wire f0;
    mux2 or_f0 (.sel(c), .in0(d), .in1(1'b1), .out(f0));

    // mux_in[1]: for ab=01 from K-map: all 0's, so constant 0
    wire f1 = 1'b0;

    // mux_in[2]: for ab=11 from K-map: 00(0),01(0),11(1),10(0)
    // f2 = c AND d = mux2(sel=c, in0=0, in1=d)
    wire f2;
    mux2 and_f2 (.sel(c), .in0(1'b0), .in1(d), .out(f2));

    // mux_in[3]: for ab=10 from K-map: 00(1),01(0),11(1),10(1)
    // f3 = c OR (NOT c AND NOT d)
    // Compute not_c AND not_d:
    wire not_c_and_not_d;
    mux2 and_tmp (.sel(not_c), .in0(1'b0), .in1(not_d), .out(not_c_and_not_d));
    // f3 = OR(c, not_c_and_not_d) = mux2(sel=c, in0=not_c_and_not_d, in1=1)
    wire f3;
    mux2 or_f3 (.sel(c), .in0(not_c_and_not_d), .in1(1'b1), .out(f3));

    assign mux_in = {f3, f2, f1, f0};
endmodule