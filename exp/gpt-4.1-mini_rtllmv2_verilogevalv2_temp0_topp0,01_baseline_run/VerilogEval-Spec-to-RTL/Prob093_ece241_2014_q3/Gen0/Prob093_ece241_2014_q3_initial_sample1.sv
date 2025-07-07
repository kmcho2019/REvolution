module mux2to1(input sel, input in0, input in1, output out);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(input c, input d, output [3:0] mux_in);
    wire not_d;
    wire c_and_d;
    wire mux0_c0; // intermediate for mux_in[0]
    wire mux3_c0; // intermediate for mux_in[3]

    // Implement not_d = ~d using mux2to1: not_d = d ? 0 : 1
    mux2to1 not_d_mux(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // mux_in[0] = if c=0 then d else 1
    // mux0_c0 = d (when c=0)
    // so mux_in[0] = mux(c, d, 1)
    // no intermediate needed

    // mux_in[1] = 0
    // constant zero

    // mux_in[2] = c & d = if c=0 then 0 else d
    // so mux_in[2] = mux(c, 1'b0, d)

    // mux_in[3] = if c=0 then ~d else 1
    // mux_in[3] = mux(c, not_d, 1)

    assign mux_in[1] = 1'b0;

    mux2to1 mux0(.sel(c), .in0(d), .in1(1'b1), .out(mux_in[0]));
    mux2to1 mux2(.sel(c), .in0(1'b0), .in1(d), .out(mux_in[2]));
    mux2to1 mux3(.sel(c), .in0(not_d), .in1(1'b1), .out(mux_in[3]));
endmodule