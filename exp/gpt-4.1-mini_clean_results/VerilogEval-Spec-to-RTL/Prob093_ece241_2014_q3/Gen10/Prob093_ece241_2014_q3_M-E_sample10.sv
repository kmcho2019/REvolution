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

    // NOT c = mux2(sel=c, in0=1, in1=0)
    wire not_c;
    mux2 not_c_mux (.sel(c),  .in0(1'b1), .in1(1'b0), .out(not_c));

    // NOT d = mux2(sel=d, in0=1, in1=0)
    wire not_d;
    mux2 not_d_mux (.sel(d),  .in0(1'b1), .in1(1'b0), .out(not_d));

    // AND c & d = mux2(sel=c, in0=0, in1=d)
    wire c_and_d;
    mux2 and_c_d_mux (.sel(c), .in0(1'b0), .in1(d), .out(c_and_d));

    // OR c + d = NOT(AND(NOT c, NOT d))
    // AND(~c, ~d) = mux2(sel=not_c, in0=0, in1=not_d)
    wire and_notc_notd;
    mux2 and_notc_notd_mux (.sel(not_c), .in0(1'b0), .in1(not_d), .out(and_notc_notd));

    // OR c + d = NOT(AND(~c, ~d)) = mux2(sel=and_notc_notd, in0=1, in1=0)
    wire c_or_d;
    mux2 or_c_d_mux (.sel(and_notc_notd), .in0(1'b1), .in1(1'b0), .out(c_or_d));

    // mux_in[0] = c + d
    assign mux_in[0] = c_or_d;

    // mux_in[1] = 0 (all zero)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d
    assign mux_in[2] = c_and_d;

    // mux_in[3] = d' + c*d = mux2(sel=d, in0=1, in1=c)
    mux2 mux_in3_mux (.sel(d), .in0(1'b1), .in1(c), .out(mux_in[3]));

endmodule