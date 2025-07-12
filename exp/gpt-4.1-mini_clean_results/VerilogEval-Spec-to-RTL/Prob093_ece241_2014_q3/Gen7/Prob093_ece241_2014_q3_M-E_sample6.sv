// 2-to-1 Multiplexer module
module mux2 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);
    wire mux_in0_low;   // intermediate mux outputs for mux_in[0]
    wire mux_in0_high;
    wire mux_in1_low;
    wire mux_in1_high;
    wire mux_in2_low;
    wire mux_in2_high;
    wire mux_in3_low;
    wire mux_in3_high;

    // mux_in[0] = ab=00 column cd=00..10: 0,1,1,1
    // cd order with c as LSb, d as MSb:
    // 00:0, 01:1, 11:1, 10:1
    // First mux stage with c selector:
    mux2 mux_in0_mux_low (
        .sel(c),
        .in0(1'b0), // cd=00
        .in1(1'b1), // cd=01
        .out(mux_in0_low)
    );
    mux2 mux_in0_mux_high (
        .sel(c),
        .in0(1'b1), // cd=10
        .in1(1'b1), // cd=11
        .out(mux_in0_high)
    );
    // Second mux stage with d selector:
    mux2 mux_in0_mux_top (
        .sel(d),
        .in0(mux_in0_low),
        .in1(mux_in0_high),
        .out(mux_in[0])
    );

    // mux_in[1] = ab=01 column: all 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = ab=11 column cd=00..10: 0,0,1,0
    // First mux stage with c selector:
    mux2 mux_in2_mux_low (
        .sel(c),
        .in0(1'b0), // cd=00
        .in1(1'b0), // cd=01
        .out(mux_in2_low)
    );
    mux2 mux_in2_mux_high (
        .sel(c),
        .in0(1'b0), // cd=10
        .in1(1'b1), // cd=11
        .out(mux_in2_high)
    );
    // Second mux stage with d selector:
    mux2 mux_in2_mux_top (
        .sel(d),
        .in0(mux_in2_low),
        .in1(mux_in2_high),
        .out(mux_in[2])
    );

    // mux_in[3] = ab=10 column cd=00..10: 1,0,1,1
    // First mux stage with c selector:
    mux2 mux_in3_mux_low (
        .sel(c),
        .in0(1'b1), // cd=00
        .in1(1'b0), // cd=01
        .out(mux_in3_low)
    );
    mux2 mux_in3_mux_high (
        .sel(c),
        .in0(1'b1), // cd=10
        .in1(1'b1), // cd=11
        .out(mux_in3_high)
    );
    // Second mux stage with d selector:
    mux2 mux_in3_mux_top (
        .sel(d),
        .in0(mux_in3_low),
        .in1(mux_in3_high),
        .out(mux_in[3])
    );

endmodule