module Mux16to1_4bit (
    input  wire [16*4-1:0] in,  // 16 inputs of 4-bit each = 64 bits
    input  wire [3:0]      sel,
    output wire [3:0]      out
);
    assign out = in[sel*4 +: 4];
endmodule

module Mux4to1_4bit (
    input  wire [4*4-1:0] in,  // 4 inputs of 4-bit each = 16 bits
    input  wire [1:0]     sel,
    output wire [3:0]     out
);
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Stage 1: 16 muxes of 16-to-1 (each selects 4 bits from 16*4=64 bits)
    // There are 256 inputs (4 bits each), grouped as 16 groups of 16 inputs.
    // Stage1 mux selection bits: sel[3:0]

    wire [3:0] stage1_out [0:15];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1
            // Select 16 consecutive 4-bit inputs for this mux:
            // Each input is 4 bits, so 16 inputs *4 = 64 bits slice.
            wire [63:0] in_slice;
            assign in_slice = in[(i*64) +: 64];
            Mux16to1_4bit u_mux16to1 (
                .in(in_slice),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 4 muxes of 16-to-1, each selects among 16 outputs from stage1
    // Stage2 mux selection bits: sel[5:4]
    wire [3:0] stage2_out [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE2
            // Concatenate 16 stage1 outputs for each stage2 mux
            // Each stage2 mux inputs: 16 * 4 bits = 64 bits
            wire [63:0] in_slice;
            integer j;
            // Build in_slice from stage1_out:
            for (j = 0; j < 16; j = j + 1) begin : concat_stage1
                assign in_slice[j*4 +: 4] = stage1_out[i*16 + j];
            end
            Mux16to1_4bit u_mux16to1_stage2 (
                .in(in_slice),
                .sel(sel[5:4]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    // Stage 3: Final mux is 4-to-1, selecting among the 4 outputs of stage2
    // Stage3 mux selection bits: sel[7:6]
    wire [15:0] stage2_concat;
    generate
        for (i = 0; i < 4; i = i + 1) begin : CONCAT_STAGE2
            assign stage2_concat[i*4 +: 4] = stage2_out[i];
        end
    endgenerate

    Mux4to1_4bit u_mux4to1_final (
        .in(stage2_concat),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule