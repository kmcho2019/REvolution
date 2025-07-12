module Mux16to1_4bit (
    input  wire [16*4-1:0] in,  // 16 inputs, each 4-bit wide, packed
    input  wire [3:0]      sel,
    output wire [3:0]      out
);
    // Directly select the 4-bit chunk indexed by sel with part-select
    assign out = in[sel*4 +: 4];
endmodule

module Mux4to1_4bit (
    input  wire [4*4-1:0] in,  // 4 inputs, each 4-bit wide, packed
    input  wire [1:0]     sel,
    output wire [3:0]     out
);
    // Directly select 4-bit chunk indexed by sel with part-select
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Stage 1: 16 instances of 16-to-1 mux, each processing 64 bits (16*4)
    // Selected by sel[3:0]
    wire [3:0] stage1_out [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1
            Mux16to1_4bit mux16_inst (
                .in(in[i*64 +: 64]),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 4 instances of 4-to-1 mux, selected by sel[5:4]
    // Each mux gets 4 of stage1_out concatenated (4*4=16 bits)
    wire [3:0] stage2_out [3:0];
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : STAGE2
            wire [15:0] stage2_in;
            // Concatenate 4 stage1 outputs, highest index first (to align with selector)
            assign stage2_in = {
                stage1_out[j*4 + 3],
                stage1_out[j*4 + 2],
                stage1_out[j*4 + 1],
                stage1_out[j*4 + 0]
            };
            Mux4to1_4bit mux4_inst (
                .in(stage2_in),
                .sel(sel[5:4]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Stage 3: final 4-to-1 mux selected by sel[7:6]
    // Concatenate all 4 stage2 outputs for final mux input
    wire [15:0] stage3_in = {
        stage2_out[3],
        stage2_out[2],
        stage2_out[1],
        stage2_out[0]
    };
    Mux4to1_4bit mux4_final (
        .in(stage3_in),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule