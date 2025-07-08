module Mux2 (
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
    wire mux_in0, mux_in2, mux_in3;

    // mux_in[0] = d ? 1 : c
    Mux2 mux0_inst (
        .sel(d),
        .in0(c),
        .in1(1'b1),
        .out(mux_in0)
    );

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = d ? c : 0
    Mux2 mux2_inst (
        .sel(d),
        .in0(1'b0),
        .in1(c),
        .out(mux_in2)
    );

    // mux_in[3] = d ? c : 1
    Mux2 mux3_inst (
        .sel(d),
        .in0(1'b1),
        .in1(c),
        .out(mux_in3)
    );

    assign mux_in[0] = mux_in0;
    assign mux_in[2] = mux_in2;
    assign mux_in[3] = mux_in3;
endmodule