module Mux16to1_4bit (
    input  wire [16*4-1:0] in, // 16 inputs, each 4-bit wide
    input  wire [3:0]      sel,
    output wire [3:0]      out
);
    // Select 4-bit slice indexed by sel
    assign out = in[sel*4 +: 4];
endmodule

module Mux4to1_4bit (
    input  wire [4*4-1:0] in, // 4 inputs, each 4-bit wide
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
    // Stage 1: sixteen 16-to-1 muxes (select sel[3:0])
    // Each mux covers 16 4-bit inputs -> 16*4 = 64 bits
    wire [3:0] stage1_out [0:15];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1
            wire [63:0] in_slice;
            assign in_slice = in[(i*64) +: 64]; // 16 * 4 bits
            Mux16to1_4bit u_mux16to1 (
                .in(in_slice),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: four 4-to-1 muxes (select sel[5:4]) over stage1_out
    // Each mux selects 4 of the stage1 outputs -> 4*4 = 16 bits input
    wire [3:0] stage2_out [0:3];
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : STAGE2
            wire [15:0] stage1_concat;
            assign stage1_concat = {
                stage1_out[j*4+3],
                stage1_out[j*4+2],
                stage1_out[j*4+1],
                stage1_out[j*4+0]
            };
            Mux4to1_4bit u_mux4to1_stage2 (
                .in(stage1_concat),
                .sel(sel[5:4]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Stage 3: final 4-to-1 mux (select sel[7:6]) over stage2_out
    wire [15:0] stage2_concat;
    assign stage2_concat = {
        stage2_out[3],
        stage2_out[2],
        stage2_out[1],
        stage2_out[0]
    };

    Mux4to1_4bit u_mux4to1_final (
        .in(stage2_concat),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule