module mux2to1(
    input wire sel,
    input wire in0,
    input wire in1,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input wire c,
    input wire d,
    output wire [3:0] mux_in
);
    // mux_in[0] = c ? 1 : d
    wire const1 = 1'b1;
    mux2to1 mux0(
        .sel(c),
        .in0(d),
        .in1(const1),
        .out(mux_in[0])
    );

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // not_d = d ? 0 : 1
    wire not_d;
    mux2to1 not_d_mux(
        .sel(d),
        .in0(1'b1),
        .in1(1'b0),
        .out(not_d)
    );

    // mux_in[2] = c ? 1 : not_d
    mux2to1 mux2(
        .sel(c),
        .in0(not_d),
        .in1(const1),
        .out(mux_in[2])
    );

    // mux_in[3] = c ? d : 0
    mux2to1 mux3(
        .sel(c),
        .in0(1'b0),
        .in1(d),
        .out(mux_in[3])
    );

endmodule