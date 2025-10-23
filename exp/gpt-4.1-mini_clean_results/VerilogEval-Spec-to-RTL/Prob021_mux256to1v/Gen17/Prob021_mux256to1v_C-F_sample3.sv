module Mux16to1_4bit (
    input  wire [16*4-1:0] in,  // 16 inputs, each 4-bit wide
    input  wire [3:0]      sel,
    output wire [3:0]      out
);
    // Use direct indexed part-select for synthesis friendliness
    assign out = in[sel*4 +: 4];
endmodule

module Mux4to1_4bit (
    input  wire [4*4-1:0] in,   // 4 inputs, each 4-bit wide
    input  wire [1:0]     sel,
    output wire [3:0]     out
);
    // Use direct indexed part-select for efficient logic
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,    // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel,   // 8-bit select
    output wire [3:0]    out    // 4-bit output
);

    // Stage 1: 16 instances of 16-to-1 4-bit mux
    // Each mux selects among 16 inputs (64 bits) using sel[3:0]
    wire [3:0] stage1_out [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1
            wire [63:0] in_slice_16;
            assign in_slice_16 = in[i*64 +: 64]; // 16 * 4 bits = 64 bits slice
            Mux16to1_4bit u_mux16to1 (
                .in(in_slice_16),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Flatten stage1_out array into a 64-bit vector for Stage 2 mux inputs
    wire [63:0] stage1_flat;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_PACK
            assign stage1_flat[i*4 +: 4] = stage1_out[i];
        end
    endgenerate

    // Stage 2: 4 instances of 4-to-1 4-bit mux
    // Each mux selects 4 inputs (16 bits) from stage1_flat using sel[5:4]
    wire [3:0] stage2_out [3:0];
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : STAGE2
            wire [15:0] in_slice_4;
            assign in_slice_4 = stage1_flat[j*16 +: 16]; // 4 * 4 bits = 16 bits
            Mux4to1_4bit u_mux4to1 (
                .in(in_slice_4),
                .sel(sel[5:4]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Flatten stage2_out array into a 16-bit vector for final mux input
    wire [15:0] stage2_flat;
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE2_PACK
            assign stage2_flat[i*4 +: 4] = stage2_out[i];
        end
    endgenerate

    // Stage 3: final 4-to-1 mux selected by sel[7:6]
    Mux4to1_4bit u_mux4to1_final (
        .in(stage2_flat),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule