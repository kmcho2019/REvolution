module mux2 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  a,  // unused internally, selector for external 4-to-1 mux
    input  b,  // unused internally
    input  c,
    input  d,
    output [3:0] mux_in
);
    wire not_c, not_d;
    wire not_c_and_not_d;
    wire and_out;      // for mux_in[0] inverter input
    wire m0, m2, m3;

    // Inverters via mux2(sel=input, in0=1, in1=0) => output = ~input
    mux2 inv_c (.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));
    mux2 inv_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // AND of not_c and not_d: (not_c & not_d) = mux2(not_c, 0, not_d)
    mux2 and_inv (.sel(not_c), .in0(1'b0), .in1(not_d), .out(not_c_and_not_d));

    // mux_in[0] = c + d = ~(~c & ~d) = invert of not_c_and_not_d
    // invert not_c_and_not_d via mux2: sel=not_c_and_not_d, in0=1, in1=0 => output = ~not_c_and_not_d
    mux2 inv_and (.sel(not_c_and_not_d), .in0(1'b1), .in1(1'b0), .out(m0));

    // mux_in[1] = 0
    wire m1 = 1'b0;

    // mux_in[2] = c & d = mux2(c, 0, d)
    mux2 and_cd (.sel(c), .in0(1'b0), .in1(d), .out(m2));

    // mux_in[3] = c + (~c & ~d) = mux2(not_c_and_not_d, 1, c)
    mux2 or_like (.sel(not_c_and_not_d), .in0(1'b1), .in1(c), .out(m3));

    assign mux_in = {m3, m2, m1, m0};

endmodule