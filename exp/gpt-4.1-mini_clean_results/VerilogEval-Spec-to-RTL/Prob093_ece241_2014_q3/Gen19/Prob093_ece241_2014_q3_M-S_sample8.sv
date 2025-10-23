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
    // mux_in[0] = d ? 1 : c
    mux2 mux0 (.sel(d), .in0(c),   .in1(1'b1), .out(mux_in[0]));

    // mux_in[1] = 0 (constant zero)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = d ? c : 0
    mux2 mux2_ (.sel(d), .in0(1'b0), .in1(c), .out(mux_in[2]));

    // mux_in[3] = d ? c : 1 (c | ~d)
    mux2 mux3 (.sel(d), .in0(1'b1), .in1(c), .out(mux_in[3]));
endmodule