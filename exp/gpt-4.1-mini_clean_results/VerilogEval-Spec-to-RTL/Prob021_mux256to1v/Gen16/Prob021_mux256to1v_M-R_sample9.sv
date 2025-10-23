module Mux16to1_4bit (
    input  wire [16*4-1:0] in,  // 16 inputs, each 4-bit wide
    input  wire [3:0]      sel,
    output wire [3:0]      out
);
    assign out = in[sel*4 +: 4];
endmodule

module Mux4to1_4bit (
    input  wire [4*4-1:0] in,  // 4 inputs, each 4-bit wide
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

    // Stage 1: 16 instances of 16-to-1 mux selected by sel[3:0]
    // Each instance operates on 64 bits: 16 inputs * 4 bits each
    wire [3:0] stage1_out [15:0];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1
            wire [16*4-1:0] stage1_inputs = in[i*64 +: 64];
            Mux16to1_4bit mux16 (
                .in(stage1_inputs),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 4 instances of 4-to-1 mux selected by sel[5:4]
    wire [3:0] stage2_out [3:0];

    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : stage2
            // Concatenate 4 stage1 outputs into a 16-bit vector for mux input
            wire [4*4-1:0] stage2_inputs = {
                stage1_out[j*4 + 3],
                stage1_out[j*4 + 2],
                stage1_out[j*4 + 1],
                stage1_out[j*4 + 0]
            };
            Mux4to1_4bit mux4 (
                .in(stage2_inputs),
                .sel(sel[5:4]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Stage 3: Final 4-to-1 mux selected by sel[7:6]
    wire [4*4-1:0] stage3_inputs = {
        stage2_out[3],
        stage2_out[2],
        stage2_out[1],
        stage2_out[0]
    };

    Mux4to1_4bit mux4_final (
        .in(stage3_inputs),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule