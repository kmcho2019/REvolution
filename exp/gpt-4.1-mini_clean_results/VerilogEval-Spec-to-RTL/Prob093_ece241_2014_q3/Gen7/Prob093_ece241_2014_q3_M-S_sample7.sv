module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Invert c and d using mux2: NOT x = mux2(sel=x, in0=1, in1=0)
    wire not_c, not_d;
    mux2 inv_c (.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));
    mux2 inv_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // AND of not_c and not_d: AND(a,b) = mux2(sel=a, in0=0, in1=b)
    wire and_notc_notd;
    mux2 and_inv (.sel(not_c), .in0(1'b0), .in1(not_d), .out(and_notc_notd));

    // OR c,d = NOT(AND(NOT c, NOT d)) = invert and_notc_notd
    wire or_cd;
    mux2 inv_and (.sel(and_notc_notd), .in0(1'b1), .in1(1'b0), .out(or_cd));

    // mux_in[0] = c + d (OR)
    wire m0 = or_cd;

    // mux_in[1] = 0
    wire m1 = 1'b0;

    // mux_in[2] = c & d
    wire m2;
    mux2 and_cd (.sel(c), .in0(1'b0), .in1(d), .out(m2));

    // mux_in[3] = mux2(d, 1, c)
    wire m3;
    mux2 mux_d_1_c (.sel(d), .in0(1'b1), .in1(c), .out(m3));

    assign mux_in = {m3, m2, m1, m0};
endmodule