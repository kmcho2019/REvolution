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
    // Invert c and d using mux2 (NOT implemented as sel=input, in0=1, in1=0)
    wire not_c, not_d;
    mux2 inv_c(.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));
    mux2 inv_d(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // f00 = d + c(~d)
    // c(~d) = AND(c, not_d) = mux2(c, 0, not_d)
    wire c_and_notd;
    mux2 and_c_notd(.sel(c), .in0(1'b0), .in1(not_d), .out(c_and_notd));
    // f00 = OR(d, c_and_notd) = mux2(d, c_and_notd, 1)
    wire f00;
    mux2 or_d_cand(.sel(d), .in0(c_and_notd), .in1(1'b1), .out(f00));

    // f01 = 0 (constant zero)
    wire f01 = 1'b0;

    // f11 = c & d = mux2(c, 0, d)
    wire f11;
    mux2 and_c_d(.sel(c), .in0(1'b0), .in1(d), .out(f11));

    // f10 = c + (~c & ~d)
    // (~c & ~d) = mux2(not_c, 0, not_d)
    wire notc_and_notd;
    mux2 and_notc_notd(.sel(not_c), .in0(1'b0), .in1(not_d), .out(notc_and_notd));
    // f10 = OR(c, notc_and_notd) = mux2(c, notc_and_notd, 1)
    wire f10;
    mux2 or_c_notcandd(.sel(c), .in0(notc_and_notd), .in1(1'b1), .out(f10));

    assign mux_in = {f10, f11, f01, f00};
endmodule