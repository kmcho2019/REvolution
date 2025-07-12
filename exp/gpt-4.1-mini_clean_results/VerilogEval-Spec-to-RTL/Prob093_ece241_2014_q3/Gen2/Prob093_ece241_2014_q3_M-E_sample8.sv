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

// --- mux_in[0] ---
// low  = mux2to1(d,0,1)
wire mux_in0_low;
mux2to1 u0_low (
    .sel(d),
    .in0(1'b0),
    .in1(1'b1),
    .out(mux_in0_low)
);

// high = mux2to1(d,1,1)
wire mux_in0_high;
mux2to1 u0_high (
    .sel(d),
    .in0(1'b1),
    .in1(1'b1),
    .out(mux_in0_high)
);

// mux_in[0] = mux2to1(c, low, high)
mux2to1 u0 (
    .sel(c),
    .in0(mux_in0_low),
    .in1(mux_in0_high),
    .out(mux_in[0])
);

// --- mux_in[1] --- constant zero (all zeroes)
assign mux_in[1] = 1'b0;

// --- mux_in[2] ---
// low  = mux2to1(d,0,0)
wire mux_in2_low;
mux2to1 u2_low (
    .sel(d),
    .in0(1'b0),
    .in1(1'b0),
    .out(mux_in2_low)
);

// high = mux2to1(d,0,1)
wire mux_in2_high;
mux2to1 u2_high (
    .sel(d),
    .in0(1'b0),
    .in1(1'b1),
    .out(mux_in2_high)
);

// mux_in[2] = mux2to1(c, low, high)
mux2to1 u2 (
    .sel(c),
    .in0(mux_in2_low),
    .in1(mux_in2_high),
    .out(mux_in[2])
);

// --- mux_in[3] ---
// low  = mux2to1(d,1,0)
wire mux_in3_low;
mux2to1 u3_low (
    .sel(d),
    .in0(1'b1),
    .in1(1'b0),
    .out(mux_in3_low)
);

// high = mux2to1(d,1,1)
wire mux_in3_high;
mux2to1 u3_high (
    .sel(d),
    .in0(1'b1),
    .in1(1'b1),
    .out(mux_in3_high)
);

// mux_in[3] = mux2to1(c, low, high)
mux2to1 u3 (
    .sel(c),
    .in0(mux_in3_low),
    .in1(mux_in3_high),
    .out(mux_in[3])
);

endmodule