module mux2 (
    input sel,
    input in0,
    input in1,
    output y
);
    assign y = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    wire zero = 1'b0;
    wire one  = 1'b1;
    wire not_d;

    // ~d implemented as mux with sel=d, 0->1, 1->0
    mux2 u_not_d (
        .sel(d),
        .in0(one),  // d=0 => output 1
        .in1(zero), // d=1 => output 0
        .y(not_d)
    );

    // mux_in[0] = c ? 1 : d
    mux2 u_mux_in0 (
        .sel(c),
        .in0(d),
        .in1(one),
        .y(mux_in[0])
    );

    // mux_in[1] = 0 (constant)
    assign mux_in[1] = zero;

    // mux_in[2] = c ? d : 0
    mux2 u_mux_in2 (
        .sel(c),
        .in0(zero),
        .in1(d),
        .y(mux_in[2])
    );

    // mux_in[3] = c ? 1 : ~d
    mux2 u_mux_in3 (
        .sel(c),
        .in0(not_d),
        .in1(one),
        .y(mux_in[3])
    );
endmodule