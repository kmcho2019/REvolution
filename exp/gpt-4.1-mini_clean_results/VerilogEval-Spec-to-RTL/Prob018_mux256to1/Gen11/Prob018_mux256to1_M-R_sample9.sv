module TwoToOneMux(
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module Mux16to1_Tree(
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    // Internal wires for each reduction stage: max 4 stages for 16 inputs
    // We'll create an array of vectors representing current mux stage outputs
    // and iteratively reduce their width by 2 at each stage until one output remains.

    // Stage signals: stage[0] = input signals, stage[1] = after first mux layer, etc.
    wire [15:0] stage0 = in;
    wire [7:0]  stage1;
    wire [3:0]  stage2;
    wire [1:0]  stage3;
    wire        stage4;

    genvar i;

    // Level 1: 16 -> 8 muxes controlled by sel[0]
    generate
        for (i = 0; i < 8; i = i + 1) begin : level1
            TwoToOneMux mux (
                .in0(stage0[2*i]),
                .in1(stage0[2*i + 1]),
                .sel(sel[0]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Level 2: 8 -> 4 muxes controlled by sel[1]
    generate
        for (i = 0; i < 4; i = i + 1) begin : level2
            TwoToOneMux mux (
                .in0(stage1[2*i]),
                .in1(stage1[2*i + 1]),
                .sel(sel[1]),
                .out(stage2[i])
            );
        end
    endgenerate

    // Level 3: 4 -> 2 muxes controlled by sel[2]
    generate
        for (i = 0; i < 2; i = i + 1) begin : level3
            TwoToOneMux mux (
                .in0(stage2[2*i]),
                .in1(stage2[2*i + 1]),
                .sel(sel[2]),
                .out(stage3[i])
            );
        end
    endgenerate

    // Level 4: 2 -> 1 mux controlled by sel[3]
    TwoToOneMux mux_final (
        .in0(stage3[0]),
        .in1(stage3[1]),
        .sel(sel[3]),
        .out(stage4)
    );

    assign out = stage4;
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    wire [15:0] chunk_out;
    genvar i;

    // For each 16-bit chunk, instantiate Mux16to1_Tree with sel[3:0]
    generate
        for (i = 0; i < 16; i = i + 1) begin : chunk_mux
            Mux16to1_Tree u_mux16 (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(chunk_out[i])
            );
        end
    endgenerate

    // Final Mux16to1_Tree selects among 16 chunk outputs with sel[7:4]
    Mux16to1_Tree final_mux (
        .in(chunk_out),
        .sel(sel[7:4]),
        .out(out)
    );
endmodule