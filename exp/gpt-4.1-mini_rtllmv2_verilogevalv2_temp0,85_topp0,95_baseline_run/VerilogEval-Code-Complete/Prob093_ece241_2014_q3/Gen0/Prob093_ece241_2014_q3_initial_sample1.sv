module mux2 (
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
    wire d_not;

    // d_not = ~d implemented as mux2 with d select, in0=1, in1=0
    mux2 d_not_mux (
        .sel(d),
        .in0(1'b1),
        .in1(1'b0),
        .out(d_not)
    );

    // mux_in[0] = c ? 1 : d = mux2 with c select, in0=d, in1=1
    mux2 mux_in0_mux (
        .sel(c),
        .in0(d),
        .in1(1'b1),
        .out(mux_in[0])
    );

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c ? d_not : 0 = mux2 with c select, in0=0, in1=d_not
    mux2 mux_in2_mux (
        .sel(c),
        .in0(1'b0),
        .in1(d_not),
        .out(mux_in[2])
    );

    // mux_in[3] = c ? 1 : d_not = mux2 with c select, in0=d_not, in1=1
    mux2 mux_in3_mux (
        .sel(c),
        .in0(d_not),
        .in1(1'b1),
        .out(mux_in[3])
    );
endmodule