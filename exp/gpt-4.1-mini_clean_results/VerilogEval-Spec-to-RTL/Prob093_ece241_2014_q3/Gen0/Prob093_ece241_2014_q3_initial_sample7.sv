module mux2to1(
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    wire tmp0, tmp1, tmp2, tmp3;

    // mux_in[0] = c ? (d ? 0 : 1) : 0
    wire mux0_d;
    mux2to1 mux0_d_inst (
        .sel(d),
        .in0(1'b1),
        .in1(1'b0),
        .out(mux0_d)
    );
    mux2to1 mux_in_0_inst (
        .sel(c),
        .in0(1'b0),
        .in1(mux0_d),
        .out(mux_in[0])
    );

    // mux_in[1] = c ? 0 : (d ? 0 : 1)
    wire mux1_d;
    mux2to1 mux1_d_inst (
        .sel(d),
        .in0(1'b1),
        .in1(1'b0),
        .out(mux1_d)
    );
    mux2to1 mux_in_1_inst (
        .sel(c),
        .in0(mux1_d),
        .in1(1'b0),
        .out(mux_in[1])
    );

    // mux_in[2] = c ? (d ? 0 : 1) : (d ? 0 : 1)
    // same as mux_in[1] d mux repeated twice
    wire mux2_d;
    mux2to1 mux2_d_inst (
        .sel(d),
        .in0(1'b1),
        .in1(1'b0),
        .out(mux2_d)
    );
    mux2to1 mux_in_2_inst (
        .sel(c),
        .in0(mux2_d),
        .in1(mux2_d),
        .out(mux_in[2])
    );

    // mux_in[3] = d ? (c ? 1 : 0) : 1
    wire mux3_c;
    mux2to1 mux3_c_inst (
        .sel(c),
        .in0(1'b0),
        .in1(1'b1),
        .out(mux3_c)
    );
    mux2to1 mux_in_3_inst (
        .sel(d),
        .in0(1'b1),
        .in1(mux3_c),
        .out(mux_in[3])
    );

endmodule