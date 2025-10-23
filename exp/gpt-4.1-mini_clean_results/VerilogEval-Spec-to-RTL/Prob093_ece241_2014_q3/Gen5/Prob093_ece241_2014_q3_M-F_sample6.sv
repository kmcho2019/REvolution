module mux2(
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input  a,    // selector input for external 4-to-1 mux (unused internally)
    input  b,    // selector input for external 4-to-1 mux (unused internally)
    input  c,
    input  d,
    output [3:0] mux_in
);
    wire mux_in0, mux_in1, mux_in2, mux_in3;
    wire not_c, not_d;

    // mux_in[0] = c ? 1 : d
    mux2 u0(.sel(c), .in0(d), .in1(1'b1), .out(mux_in0));

    // mux_in[1] = 0 (constant zero)
    assign mux_in1 = 1'b0;

    // mux_in[2] = c ? d : 0
    mux2 u2(.sel(c), .in0(1'b0), .in1(d), .out(mux_in2));

    // ~c = mux2(c, 1, 0)
    mux2 u_not_c(.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));

    // ~d = mux2(d, 1, 0)
    mux2 u_not_d(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // mux_in[3] = xor(~c, d) = mux2(~c, d, ~d)
    mux2 u3(.sel(not_c), .in0(d), .in1(not_d), .out(mux_in3));

    assign mux_in = {mux_in3, mux_in2, mux_in1, mux_in0};

endmodule