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

    // NOT c = ~c = mux2(c,1,0)
    wire not_c;
    mux2 not_c_mux (.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));

    // NOT d = ~d = mux2(d,1,0)
    wire not_d;
    mux2 not_d_mux (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // AND inv_c & inv_d = mux2(inv_c,0,inv_d)
    wire and_notc_notd;
    mux2 and_notc_notd_mux (.sel(not_c), .in0(1'b0), .in1(not_d), .out(and_notc_notd));

    // NOT (and_notc_notd) = c + d = mux_in[0]
    mux2 or_c_d_mux (.sel(and_notc_notd), .in0(1'b1), .in1(1'b0), .out(mux_in[0]));

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // AND c & d = mux2(c,0,d)
    wire and_c_d;
    mux2 and_c_d_mux (.sel(c), .in0(1'b0), .in1(d), .out(and_c_d));
    assign mux_in[2] = and_c_d;

    // mux_in[3] = d' + c*d = mux2(d,1,c)
    mux2 mux_in3_mux (.sel(d), .in0(1'b1), .in1(c), .out(mux_in[3]));

endmodule