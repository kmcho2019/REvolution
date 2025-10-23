// 2-to-1 Mux module
module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);
    wire mux_in0; // ab=00 column
    wire mux_in1; // ab=01 column
    wire mux_in2; // ab=11 column
    wire mux_in3; // ab=10 column

    // mux_in[0] = d ? 1 : c;
    // Use 2-to-1 mux: out = sel ? in1 : in0
    mux2 mux_in0_mux (
        .sel(d),
        .in0(c),
        .in1(1'b1),
        .out(mux_in0)
    );

    // mux_in[1] = 0 (constant zero)
    assign mux_in1 = 1'b0;

    // mux_in[2] = d ? c : 0;
    mux2 mux_in2_mux (
        .sel(d),
        .in0(1'b0),
        .in1(c),
        .out(mux_in2)
    );

    // mux_in[3] = d ? c : 1;
    mux2 mux_in3_mux (
        .sel(d),
        .in0(1'b1),
        .in1(c),
        .out(mux_in3)
    );

    assign mux_in = {mux_in3, mux_in1, mux_in2, mux_in0};
    // Note: order of bits:
    // mux_in[3] = ab=10 column (index 3)
    // mux_in[2] = ab=11 column (index 2)
    // mux_in[1] = ab=01 column (index 1)
    // mux_in[0] = ab=00 column (index 0)

endmodule