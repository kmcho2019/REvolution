module TwoToOneMux(
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    // mux_in[0] = d ? 1 : c
    wire mux0;
    TwoToOneMux mux0_inst(
        .sel(d),
        .in0(c),
        .in1(1'b1),
        .out(mux0)
    );

    // mux_in[1] = 0
    wire mux1 = 1'b0;

    // mux_in[2] = c ? d : 0
    wire mux2;
    TwoToOneMux mux2_inst(
        .sel(c),
        .in0(1'b0),
        .in1(d),
        .out(mux2)
    );

    // mux_in[3] = d ? c : 1
    wire mux3;
    TwoToOneMux mux3_inst(
        .sel(d),
        .in0(1'b1),
        .in1(c),
        .out(mux3)
    );

    assign mux_in = {mux3, mux2, mux1, mux0};
endmodule