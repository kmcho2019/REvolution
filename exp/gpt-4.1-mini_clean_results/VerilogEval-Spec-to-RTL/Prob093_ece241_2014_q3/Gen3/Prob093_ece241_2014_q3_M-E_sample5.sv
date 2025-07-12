module mux2(
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);
    wire m0, m1, m3;

    // mux_in[0] = c ? 1 : d
    mux2 u0(.sel(c), .in0(d), .in1(1'b1), .out(m0));

    // mux_in[1] = 0 (constant zero)
    // No mux needed, assign directly
    wire zero = 1'b0;

    // mux_in[2] = c ? d : 0
    mux2 u2(.sel(c), .in0(1'b0), .in1(d), .out(m1));

    // mux_in[3] = d ? c : 1  <== mux2 with sel=d, in0=1, in1=c
    mux2 u3(.sel(d), .in0(1'b1), .in1(c), .out(m3));

    assign mux_in = {m3, m1, zero, m0};

endmodule