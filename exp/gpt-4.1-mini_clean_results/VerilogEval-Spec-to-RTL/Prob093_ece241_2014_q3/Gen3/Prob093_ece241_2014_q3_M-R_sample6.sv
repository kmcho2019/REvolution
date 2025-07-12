module mux2to1 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

// --- mux_in[0] --- ab=00
// cd=00=0, cd=01=1, cd=10=1, cd=11=1
// low  = mux2to1(d, cd=00, cd=01) = mux2to1(d,0,1)
// high = mux2to1(d, cd=10, cd=11) = mux2to1(d,1,1)
wire mux_in0_low, mux_in0_high;
mux2to1 u0_low (
    .sel(d),
    .in0(1'b0),
    .in1(1'b1),
    .out(mux_in0_low)
);
mux2to1 u0_high (
    .sel(d),
    .in0(1'b1),
    .in1(1'b1),
    .out(mux_in0_high)
);
mux2to1 u0 (
    .sel(c),
    .in0(mux_in0_low),
    .in1(mux_in0_high),
    .out(mux_in[0])
);

// --- mux_in[1] --- ab=01
// All zero, direct assign
assign mux_in[1] = 1'b0;

// --- mux_in[2] --- ab=11
// cd=00=0, cd=01=0, cd=10=1, cd=11=0
// low  = mux2to1(d, 0, 0)
// high = mux2to1(d, 1, 0)
wire mux_in2_low, mux_in2_high;
mux2to1 u2_low (
    .sel(d),
    .in0(1'b0),
    .in1(1'b0),
    .out(mux_in2_low)
);
mux2to1 u2_high (
    .sel(d),
    .in0(1'b1),
    .in1(1'b0),
    .out(mux_in2_high)
);
mux2to1 u2 (
    .sel(c),
    .in0(mux_in2_low),
    .in1(mux_in2_high),
    .out(mux_in[2])
);

// --- mux_in[3] --- ab=10
// cd=00=1, cd=01=0, cd=10=1, cd=11=1
// low  = mux2to1(d, 1, 0)
// high = mux2to1(d, 1, 1)
wire mux_in3_low, mux_in3_high;
mux2to1 u3_low (
    .sel(d),
    .in0(1'b1),
    .in1(1'b0),
    .out(mux_in3_low)
);
mux2to1 u3_high (
    .sel(d),
    .in0(1'b1),
    .in1(1'b1),
    .out(mux_in3_high)
);
mux2to1 u3 (
    .sel(c),
    .in0(mux_in3_low),
    .in1(mux_in3_high),
    .out(mux_in[3])
);

endmodule