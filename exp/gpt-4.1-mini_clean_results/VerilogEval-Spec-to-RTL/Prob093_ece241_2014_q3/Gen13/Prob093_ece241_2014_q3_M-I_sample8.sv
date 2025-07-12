module mux2to1 (
    input  in0,
    input  in1,
    input  sel,
    output out
);
    // 2-to-1 multiplexer: out = sel ? in1 : in0
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] corresponds to ab=00 column of K-map:
    // For c=0 -> output = d
    // For c=1 -> output = 1
    // mux_in[0] = mux2to1(d, 1, c)
    mux2to1 mux_in0_mux (
        .in0(d),
        .in1(1'b1),
        .sel(c),
        .out(mux_in[0])
    );

    // mux_in[1] corresponds to ab=01 column (all zeros)
    assign mux_in[1] = 1'b0;

    // mux_in[2] corresponds to ab=11 column:
    // For c=0 -> output=0
    // For c=1 -> output=d
    // mux_in[2] = mux2to1(0, d, c)
    mux2to1 mux_in2_mux (
        .in0(1'b0),
        .in1(d),
        .sel(c),
        .out(mux_in[2])
    );

    // mux_in[3] corresponds to ab=10 column:
    // For c=0 -> output = ~d
    // For c=1 -> output = 1
    //
    // Implement ~d as mux2to1(1,0,d)
    wire not_d;
    mux2to1 not_d_mux (
        .in0(1'b1),
        .in1(1'b0),
        .sel(d),
        .out(not_d)
    );
    // Final mux_in[3] = mux2to1(not_d, 1, c)
    mux2to1 mux_in3_mux (
        .in0(not_d),
        .in1(1'b1),
        .sel(c),
        .out(mux_in[3])
    );
endmodule