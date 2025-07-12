module mux2to1 (
    input sel,
    input in0,
    input in1,
    output out
);
    // 2-to-1 multiplexer
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

// Intermediate wires for internal mux outputs
wire not_d;       // not d implemented as mux(d,1,0)
wire mux_in3_d;   // mux(d,1,0) for mux_in[3]

// Implement not_d = mux(d,1,0)
mux2to1 u_not_d (
    .sel(d),
    .in0(1'b1),
    .in1(1'b0),
    .out(not_d)
);

// mux_in[0] = mux(d, c, 1)
mux2to1 u_mux_in0 (
    .sel(d),
    .in0(c),
    .in1(1'b1),
    .out(mux_in[0])
);

// mux_in[1] = 0 (constant)
assign mux_in[1] = 1'b0;

// mux_in[2] = mux(c, 0, d)
mux2to1 u_mux_in2 (
    .sel(c),
    .in0(1'b0),
    .in1(d),
    .out(mux_in[2])
);

// mux_in3_d = mux(d,1,0) = not_d (already computed)
assign mux_in3_d = not_d;

// mux_in[3] = mux(c, mux_in3_d, 1)
mux2to1 u_mux_in3 (
    .sel(c),
    .in0(mux_in3_d),
    .in1(1'b1),
    .out(mux_in[3])
);

endmodule