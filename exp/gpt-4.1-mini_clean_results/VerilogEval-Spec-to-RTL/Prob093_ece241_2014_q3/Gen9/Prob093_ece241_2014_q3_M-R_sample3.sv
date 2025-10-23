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
    // Implement NOT using mux2: NOT x = mux2(sel=x, in0=1, in1=0)
    wire not_c, not_d;
    mux2 not_c_mux (.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));
    mux2 not_d_mux (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // Implement AND(x,y) = mux2(sel=x, in0=0, in1=y)
    // Implement OR(x,y) = NOT(AND(NOT x, NOT y))

    // mux_in[0] corresponds to ab=00 column in K-map: {c,d} = output from K-map column 00
    // Values for ab=00 from K-map columns cd=00 to 11: 0,1,1,1 
    // So mux_in[0] = (~c & d) | (c & d) | (c & ~d) = d | (c & ~d)
    // OR form: d + (c & ~d)

    // First compute (c & ~d)
    wire and_c_notd;
    mux2 and_c_notd_mux (.sel(c), .in0(1'b0), .in1(not_d), .out(and_c_notd));
    // Then OR(d, and_c_notd) = NOT(AND(NOT d, NOT and_c_notd))
    wire not_d_and_not_and_c_notd;
    wire not_and_c_notd;
    mux2 not_and_c_notd_mux (.sel(and_c_notd), .in0(1'b1), .in1(1'b0), .out(not_and_c_notd));
    mux2 and_notd_not_and_c_notd_mux (.sel(not_d), .in0(1'b0), .in1(not_and_c_notd), .out(not_d_and_not_and_c_notd));
    mux2 or_d_andcnotd_mux (.sel(not_d_and_not_and_c_notd), .in0(1'b1), .in1(1'b0), .out(mux_in[0]));

    // mux_in[1] corresponds to ab=01 column in K-map: 0,0,0,0 (all zero)
    assign mux_in[1] = 1'b0;

    // mux_in[2] corresponds to ab=11 column in K-map: 0,0,1,0
    // That means output= c & d (only true when c=1,d=1)
    wire and_c_d;
    mux2 and_c_d_mux (.sel(c), .in0(1'b0), .in1(d), .out(and_c_d));
    assign mux_in[2] = and_c_d;

    // mux_in[3] corresponds to ab=10 column in K-map: 1,0,1,1
    // Expression: (~d) | (c & d)
    // Step 1: compute (c & d)
    wire and_c_d_3;
    mux2 and_c_d_3_mux (.sel(c), .in0(1'b0), .in1(d), .out(and_c_d_3));
    // Step 2: OR(~d, and_c_d_3) = NOT(AND(d, NOT and_c_d_3))
    wire not_and_d_not_and_c_d_3;
    wire not_and_c_d_3;
    mux2 not_and_c_d_3_mux (.sel(and_c_d_3), .in0(1'b1), .in1(1'b0), .out(not_and_c_d_3));
    mux2 and_d_not_and_c_d_3_mux (.sel(d), .in0(1'b0), .in1(not_and_c_d_3), .out(not_and_d_not_and_c_d_3));
    mux2 or_notd_andc_d_mux (.sel(not_and_d_not_and_c_d_3), .in0(1'b1), .in1(1'b0), .out(mux_in[3]));

endmodule