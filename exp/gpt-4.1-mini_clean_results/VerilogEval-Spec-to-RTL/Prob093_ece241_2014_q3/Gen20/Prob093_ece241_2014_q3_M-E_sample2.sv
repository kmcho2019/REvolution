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
    // From the problem K-map:
    //
    //        ab
    //    cd  00  01  11  10
    //    00 | 0 | 0 | 0 | 1 |
    //    01 | 1 | 0 | 0 | 0 |
    //    11 | 1 | 0 | 1 | 1 |
    //    10 | 1 | 0 | 0 | 1 |
    //
    // Each mux_in[i] corresponds to fixed ab:
    // mux_in[0] = ab=00 column: cd=00->0,01->1,11->1,10->1
    // mux_in[1] = ab=01 column: cd=00->0,01->0,11->0,10->0
    // mux_in[2] = ab=11 column: cd=00->0,01->0,11->1,10->0
    // mux_in[3] = ab=10 column: cd=00->1,01->0,11->1,10->1

    // We'll implement each mux_in[i] = f_i(c,d) using mux2 modules only.

    // First, implement mux_in[0]:
    // cd: 00=0, 01=1, 11=1, 10=1
    // Truth table (c d):
    // c d | f0
    // 0 0 | 0
    // 0 1 | 1
    // 1 1 | 1
    // 1 0 | 1
    //
    // Try d as selector:
    // d=0 => c=0->0, c=1->1
    // d=1 => c=0->1, c=1->1
    // So:
    // f0 = mux2(sel=d, in0=c, in1=1)
    wire f0;
    mux2 mux0 (.sel(d), .in0(c), .in1(1'b1), .out(f0));

    // mux_in[1]:
    // cd: all zeros
    // So output is constant zero
    wire f1 = 1'b0;

    // mux_in[2]:
    // cd: 00=0, 01=0, 11=1, 10=0
    // c d | f2
    // 0 0 | 0
    // 0 1 | 0
    // 1 1 | 1
    // 1 0 | 0
    //
    // Choose c as selector:
    // c=0 => d=0->0, d=1->0 (always 0)
    // c=1 => d=0->0, d=1->1
    // So f2 = mux2(sel=c, in0=0, in1=d)
    wire f2;
    mux2 mux2_inst (.sel(c), .in0(1'b0), .in1(d), .out(f2));

    // mux_in[3]:
    // cd: 00=1, 01=0, 11=1, 10=1
    // c d | f3
    // 0 0 | 1
    // 0 1 | 0
    // 1 1 | 1
    // 1 0 | 1
    //
    // Try d as selector:
    // d=0 => c=0->1, c=1->1 (always 1)
    // d=1 => c=0->0, c=1->1
    // So f3 = mux2(sel=d, in0=1, in1=c)
    wire f3;
    mux2 mux3 (.sel(d), .in0(1'b1), .in1(c), .out(f3));

    assign mux_in = {f3, f2, f1, f0};
endmodule