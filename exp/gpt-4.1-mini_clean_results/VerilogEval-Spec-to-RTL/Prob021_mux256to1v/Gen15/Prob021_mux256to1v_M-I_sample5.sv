module Mux4to1_4bit (
    input  wire [4*4-1:0] in,  // 4 inputs, each 4-bit wide
    input  wire [1:0]     sel,
    output wire [3:0]     out
);
    // Select 4-bit slice according to sel (0 to 3)
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,  // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel, // 8-bit select
    output wire [3:0]    out  // 4-bit output
);

    // Stage 0: 256 inputs grouped into 64 groups of 4 inputs
    // Each 4-to-1 mux selects one 4-bit input from 4 inputs based on sel[1:0]
    wire [3:0] stage0_out [63:0];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE0_MUX4
            // Each input group: 4 inputs *4 bits = 16 bits slice
            wire [15:0] in_slice = in[i*16 +: 16];
            Mux4to1_4bit mux0 (
                .in(in_slice),
                .sel(sel[1:0]),
                .out(stage0_out[i])
            );
        end
    endgenerate

    // Stage 1: 64 outputs from stage0 grouped into 16 groups of 4 inputs
    wire [3:0] stage1_out [15:0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_MUX4
            wire [15:0] in_slice;
            // Pack 4 stage0 outputs into a 16-bit input for 4-to-1 mux
            assign in_slice = {
                stage0_out[i*4 + 3],
                stage0_out[i*4 + 2],
                stage0_out[i*4 + 1],
                stage0_out[i*4 + 0]
            };
            // Concatenate 4 outputs into 16 bits (4*4 bits)
            // The previous line concatenates 4x4bit outputs, so correction:
            // We need to pack the 4 4-bit values into 16 bits:
            assign in_slice = {
                stage0_out[i*4 + 3],
                stage0_out[i*4 + 2],
                stage0_out[i*4 + 1],
                stage0_out[i*4 + 0]
            }; // will cause width mismatch, must expand correctly
            // Instead, pack manually:
            wire [15:0] packed_in_slice = {stage0_out[i*4+3], stage0_out[i*4+2], stage0_out[i*4+1], stage0_out[i*4]};
            // Use packed_in_slice as input to mux
            Mux4to1_4bit mux1 (
                .in(packed_in_slice),
                .sel(sel[3:2]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 16 outputs from stage1 grouped into 4 groups of 4 inputs
    wire [3:0] stage2_out [3:0];
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE2_MUX4
            wire [15:0] packed_in_slice = {stage1_out[i*4+3], stage1_out[i*4+2], stage1_out[i*4+1], stage1_out[i*4]};
            Mux4to1_4bit mux2 (
                .in(packed_in_slice),
                .sel(sel[5:4]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    // Stage 3: 4 outputs from stage2, final 4-to-1 mux selects output
    wire [15:0] packed_stage2_out = {stage2_out[3], stage2_out[2], stage2_out[1], stage2_out[0]};
    Mux4to1_4bit mux3 (
        .in(packed_stage2_out),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule