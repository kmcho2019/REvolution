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
    wire not_c, not_d;

    // Implement NOT c and NOT d using mux2 (sel=input, in0=1, in1=0) -> output = ~input
    mux2 inv_c (.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));
    mux2 inv_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // mux_in[0]: F0 = d + c(~d) = mux2(c, d, 1)
    wire m0;
    mux2 m0_mux (.sel(c), .in0(d), .in1(1'b1), .out(m0));

    // mux_in[1]: F1 = 0
    wire m1 = 1'b0;

    // mux_in[2]: F2 = c & d = mux2(c, 0, d)
    wire m2;
    mux2 m2_mux (.sel(c), .in0(1'b0), .in1(d), .out(m2));

    // mux_in[3]: F3 = c + (~c & ~d)
    // Compute ~c & ~d = mux2(not_c, 0, not_d)
    wire not_c_and_not_d;
    mux2 and_notc_notd (.sel(not_c), .in0(1'b0), .in1(not_d), .out(not_c_and_not_d));
    // F3 = mux2(not_c_and_not_d, 1, c)
    wire m3;
    mux2 m3_mux (.sel(not_c_and_not_d), .in0(1'b1), .in1(c), .out(m3));

    assign mux_in = {m3, m2, m1, m0};

endmodule