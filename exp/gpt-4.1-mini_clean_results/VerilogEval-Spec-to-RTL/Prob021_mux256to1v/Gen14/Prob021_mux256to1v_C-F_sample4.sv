module Mux4to1_4bit (
    input  wire [4*4-1:0] in, // 4 inputs, each 4-bit wide concatenated
    input  wire [1:0]     sel,
    output reg  [3:0]     out
);
    always @(*) begin
        case (sel)
            2'd0: out = in[4*0 +: 4];
            2'd1: out = in[4*1 +: 4];
            2'd2: out = in[4*2 +: 4];
            2'd3: out = in[4*3 +: 4];
            default: out = 4'b0000;
        endcase
    end
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Stage 1: 64 x 4-to-1 muxes; each selects among 4 inputs (sel[1:0])
    wire [3:0] stage1_out [63:0];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE1
            // Slice 16 bits: 4 inputs * 4 bits, each input = in[(input_idx)*4 +:4]
            // Inputs for this mux: inputs # (i*4) to (i*4+3)
            wire [15:0] in_slice = in[i*16 +: 16];
            Mux4to1_4bit mux4to1_stage1 (
                .in(in_slice),
                .sel(sel[1:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 16 x 4-to-1 muxes; each selects among 4 outputs from stage1 (sel[3:2])
    wire [3:0] stage2_out [15:0];
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : STAGE2
            wire [15:0] in_stage2 = {
                stage1_out[j*4 + 3],
                stage1_out[j*4 + 2],
                stage1_out[j*4 + 1],
                stage1_out[j*4 + 0]
            };
            Mux4to1_4bit mux4to1_stage2 (
                .in(in_stage2),
                .sel(sel[3:2]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Stage 3: 4 x 4-to-1 muxes; select among 4 outputs from stage2 (sel[5:4])
    wire [3:0] stage3_out [3:0];
    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : STAGE3
            wire [15:0] in_stage3 = {
                stage2_out[k*4 + 3],
                stage2_out[k*4 + 2],
                stage2_out[k*4 + 1],
                stage2_out[k*4 + 0]
            };
            Mux4to1_4bit mux4to1_stage3 (
                .in(in_stage3),
                .sel(sel[5:4]),
                .out(stage3_out[k])
            );
        end
    endgenerate

    // Stage 4: final 4-to-1 mux selects among 4 outputs from stage3 (sel[7:6])
    wire [15:0] in_stage4 = {
        stage3_out[3],
        stage3_out[2],
        stage3_out[1],
        stage3_out[0]
    };
    Mux4to1_4bit mux4to1_stage4 (
        .in(in_stage4),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule