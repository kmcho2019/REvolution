module mux2to1 (
    input  in0,
    input  in1,
    input  sel,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] (ab=00): F = c ? d : 0
    mux2to1 mux_in0 (
        .in0(1'b0),
        .in1(d),
        .sel(c),
        .out(mux_in[0])
    );

    // mux_in[1] (ab=01): all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2] (ab=11): F = c ? d : 0
    mux2to1 mux_in2 (
        .in0(1'b0),
        .in1(d),
        .sel(c),
        .out(mux_in[2])
    );

    // not_d = ~d implemented with mux2to1(1,0,d)
    wire not_d;
    mux2to1 not_d_mux (
        .in0(1'b1),
        .in1(1'b0),
        .sel(d),
        .out(not_d)
    );

    // mux_in[3] (ab=10): F = c ? 1 : ~d
    mux2to1 mux_in3 (
        .in0(not_d),
        .in1(1'b1),
        .sel(c),
        .out(mux_in[3])
    );
endmodule