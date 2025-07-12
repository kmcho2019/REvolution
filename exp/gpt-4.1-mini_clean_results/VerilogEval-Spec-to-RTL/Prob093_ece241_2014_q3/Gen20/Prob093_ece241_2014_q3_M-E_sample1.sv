module mux2to1 (
    input  sel,
    input  d0,
    input  d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] = d ? 1 : c
    wire mux_in0;
    mux2to1 u0 (.sel(d), .d0(c), .d1(1'b1), .y(mux_in0));

    // mux_in[1] = 0
    wire mux_in1 = 1'b0;

    // mux_in[2] = d ? c : 0
    wire mux_in2;
    mux2to1 u2 (.sel(d), .d0(1'b0), .d1(c), .y(mux_in2));

    // mux_in[3] = d ? c : 1
    wire mux_in3;
    mux2to1 u3 (.sel(d), .d0(1'b1), .d1(c), .y(mux_in3));

    assign mux_in = {mux_in3, mux_in2, mux_in1, mux_in0};
endmodule