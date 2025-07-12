module Mux16to1_4bit (
    input  wire [16*4-1:0] in,  // 16 inputs, each 4-bit wide concatenated
    input  wire [3:0]      sel,
    output wire [3:0]      out
);
    // Direct indexed select from array of inputs
    assign out = in[sel*4 +: 4];
endmodule

module Mux4to1_4bit (
    input  wire [4*4-1:0] in,  // 4 inputs, each 4-bit wide concatenated
    input  wire [1:0]     sel,
    output wire [3:0]     out
);
    assign out = in[sel*4 +: 4];
endmodule

module Mux64to1_4bit (
    input  wire [64*4-1:0] in,  // 64 inputs * 4 bits = 256 bits
    input  wire [5:0]      sel, // 6-bit select for 64 inputs
    output wire [3:0]      out
);
    // Lower 4 bits select one of 16 inputs (16-to-1 mux)
    wire [3:0] mux16_out [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : mux16_stage
            // Each 16-to-1 mux gets 16 inputs (16*4=64 bits)
            wire [16*4-1:0] slice_16;
            assign slice_16 = in[(i*16*4) +: 16*4];
            Mux16to1_4bit mux16 (
                .in(slice_16),
                .sel(sel[3:0]),
                .out(mux16_out[i])
            );
        end
    endgenerate

    // 4-to-1 mux selects among the four 16-to-1 outputs, using sel[5:4]
    wire [4*4-1:0] mux4_in = {mux16_out[3], mux16_out[2], mux16_out[1], mux16_out[0]};
    Mux4to1_4bit mux4 (
        .in(mux4_in),
        .sel(sel[5:4]),
        .out(out)
    );
endmodule

module TopModule (
    input  wire [1023:0] in,   // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel,  // 8-bit select
    output wire [3:0]    out   // 4-bit output
);

    // Stage 1: 4 instances of 64-to-1 4-bit mux, selected by sel[5:0]
    wire [3:0] stage1_out [3:0];

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage1_mux64
            wire [64*4-1:0] slice_64 = in[i*256 +: 256]; // 64*4=256 bits
            Mux64to1_4bit mux64 (
                .in(slice_64),
                .sel(sel[5:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: Final 4-to-1 mux selects among 4 outputs from stage1 using sel[7:6]
    wire [4*4-1:0] stage2_in = {stage1_out[3], stage1_out[2], stage1_out[1], stage1_out[0]};
    Mux4to1_4bit mux4_final (
        .in(stage2_in),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule