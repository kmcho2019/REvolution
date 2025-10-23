module mux2 (
    input sel,
    input in0,
    input in1,
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
    wire not_c, not_d;

    // Inverters implemented as mux2 with sel=input, output = ~input
    mux2 inv_c (.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));
    mux2 inv_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // mux_in[0] = c + d = mux2(not_c, 1, d)
    wire m0;
    mux2 u0 (.sel(not_c), .in0(1'b1), .in1(d), .out(m0));

    // mux_in[1] = 0
    wire m1 = 1'b0;

    // mux_in[2] = c & d = mux2(c, 0, d)
    wire m2;
    mux2 u2 (.sel(c), .in0(1'b0), .in1(d), .out(m2));

    // mux_in[3] = ~d = not_d
    wire m3 = not_d;

    assign mux_in = {m3, m2, m1, m0};

endmodule