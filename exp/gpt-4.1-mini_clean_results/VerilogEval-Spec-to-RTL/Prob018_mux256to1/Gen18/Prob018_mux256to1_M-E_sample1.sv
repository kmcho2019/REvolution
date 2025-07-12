module Mux2to1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Declare wires for each stage: stage 0 holds the input bits,
    // stages 1 to 8 progressively reduce the width by half.
    // stage 0 = 256 bits (input)
    // stage 1 = 128 bits
    // stage 2 = 64 bits
    // stage 3 = 32 bits
    // stage 4 = 16 bits
    // stage 5 = 8 bits
    // stage 6 = 4 bits
    // stage 7 = 2 bits
    // stage 8 = 1 bit (final output)
    
    wire [255:0] stage0 = in;
    wire [127:0] stage1;
    wire [63:0]  stage2;
    wire [31:0]  stage3;
    wire [15:0]  stage4;
    wire [7:0]   stage5;
    wire [3:0]   stage6;
    wire [1:0]   stage7;
    wire         stage8;

    genvar i;

    // Stage 1 muxes: select between pairs of bits using sel[0]
    generate
        for (i = 0; i < 128; i = i + 1) begin : stage1_loop
            Mux2to1 mux2to1_inst (
                .in0(stage0[i*2]),
                .in1(stage0[i*2 + 1]),
                .sel(sel[0]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2 muxes: select between pairs using sel[1]
    generate
        for (i = 0; i < 64; i = i + 1) begin : stage2_loop
            Mux2to1 mux2to1_inst (
                .in0(stage1[i*2]),
                .in1(stage1[i*2 + 1]),
                .sel(sel[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Stage 3 muxes: sel[2]
    generate
        for (i = 0; i < 32; i = i + 1) begin : stage3_loop
            Mux2to1 mux2to1_inst (
                .in0(stage2[i*2]),
                .in1(stage2[i*2 + 1]),
                .sel(sel[2]),
                .out(stage3[i])
            );
        end
    endgenerate

    // Stage 4 muxes: sel[3]
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage4_loop
            Mux2to1 mux2to1_inst (
                .in0(stage3[i*2]),
                .in1(stage3[i*2 + 1]),
                .sel(sel[3]),
                .out(stage4[i])
            );
        end
    endgenerate

    // Stage 5 muxes: sel[4]
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage5_loop
            Mux2to1 mux2to1_inst (
                .in0(stage4[i*2]),
                .in1(stage4[i*2 + 1]),
                .sel(sel[4]),
                .out(stage5[i])
            );
        end
    endgenerate

    // Stage 6 muxes: sel[5]
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage6_loop
            Mux2to1 mux2to1_inst (
                .in0(stage5[i*2]),
                .in1(stage5[i*2 + 1]),
                .sel(sel[5]),
                .out(stage6[i])
            );
        end
    endgenerate

    // Stage 7 muxes: sel[6]
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage7_loop
            Mux2to1 mux2to1_inst (
                .in0(stage6[i*2]),
                .in1(stage6[i*2 + 1]),
                .sel(sel[6]),
                .out(stage7[i])
            );
        end
    endgenerate

    // Stage 8 mux: sel[7] final bit
    Mux2to1 final_mux (
        .in0(stage7[0]),
        .in1(stage7[1]),
        .sel(sel[7]),
        .out(stage8)
    );

    assign out = stage8;

endmodule