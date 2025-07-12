module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Internal mux2X1 module definition
    module mux2X1(
        input [7:0] in0,
        input [7:0] in1,
        input sel,
        output [7:0] out
    );
        assign out = sel ? in1 : in0;
    endmodule

    // Stage 1: 4-bit rotation
    wire [7:0] stage1_out;
    mux2X1 stage1_mux(
        .in0(in),
        .in1({in[3:0], in[7:4]}),
        .sel(ctrl[2]),
        .out(stage1_out)
    );

    // Stage 2: 2-bit rotation
    wire [7:0] stage2_out;
    mux2X1 stage2_mux(
        .in0(stage1_out),
        .in1({stage1_out[1:0], stage1_out[7:2]}),
        .sel(ctrl[1]),
        .out(stage2_out)
    );

    // Stage 3: 1-bit rotation
    mux2X1 stage3_mux(
        .in0(stage2_out),
        .in1({stage2_out[0], stage2_out[7:1]}),
        .sel(ctrl[0]),
        .out(out)
    );
endmodule