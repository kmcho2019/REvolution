module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

// 2-to-1 multiplexer module
// out = sel ? in1 : in0
module mux2to1 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// Create instances of mux2to1 to build the logic

wire not_d;
mux2to1 u_not_d (
    .sel(d),
    .in0(1'b1),
    .in1(1'b0),
    .out(not_d)
);

// mux_in[0] = c ? 1 : d
wire mux_in0;
mux2to1 u_mux_in0 (
    .sel(c),
    .in0(d),
    .in1(1'b1),
    .out(mux_in0)
);

// mux_in[1] = 0
// assign directly
wire mux_in1 = 1'b0;

// mux_in[2] = c ? d : 0
wire mux_in2;
mux2to1 u_mux_in2 (
    .sel(c),
    .in0(1'b0),
    .in1(d),
    .out(mux_in2)
);

// mux_in[3] = c ? 1 : ~d
wire mux_in3;
mux2to1 u_mux_in3 (
    .sel(c),
    .in0(not_d),
    .in1(1'b1),
    .out(mux_in3)
);

assign mux_in = {mux_in3, mux_in2, mux_in1, mux_in0};

endmodule