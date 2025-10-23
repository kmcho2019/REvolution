module mux2to1(
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

    // mux_in[0] = c ? (d ? 0 : 1) : 0
    // Implementation:
    // if c=0 -> output=0
    // if c=1 -> output = d ? 0 : 1
    wire mux0_d;
    mux2to1 mux0_d_inst (
        .sel(d),
        .in0(1'b1),
        .in1(1'b0),
        .out(mux0_d)
    );
    mux2to1 mux_in0_inst (
        .sel(c),
        .in0(1'b0),
        .in1(mux0_d),
        .out(mux_in[0])
    );

    // mux_in[1] = c ? 0 : (d ? 0 : 1)
    // Implementation:
    // if c=0 -> output = d ? 0 : 1
    // if c=1 -> output = 0
    wire mux1_d;
    mux2to1 mux1_d_inst (
        .sel(d),
        .in0(1'b1),
        .in1(1'b0),
        .out(mux1_d)
    );
    mux2to1 mux_in1_inst (
        .sel(c),
        .in0(mux1_d),
        .in1(1'b0),
        .out(mux_in[1])
    );

    // mux_in[2] = c ? (d ? 0 : 1) : (d ? 0 : 1)
    // Both branches same, so mux_in[2] = (d ? 0 : 1)
    mux2to1 mux_in2_inst (
        .sel(d),
        .in0(1'b1),
        .in1(1'b0),
        .out(mux_in[2])
    );

    // mux_in[3] = d ? (c ? 1 : 0) : 1
    // Implementation:
    // if d=0 -> output=1
    // if d=1 -> output = c ? 1 : 0
    wire mux3_c;
    mux2to1 mux3_c_inst (
        .sel(c),
        .in0(1'b0),
        .in1(1'b1),
        .out(mux3_c)
    );
    mux2to1 mux_in3_inst (
        .sel(d),
        .in0(1'b1),
        .in1(mux3_c),
        .out(mux_in[3])
    );

endmodule