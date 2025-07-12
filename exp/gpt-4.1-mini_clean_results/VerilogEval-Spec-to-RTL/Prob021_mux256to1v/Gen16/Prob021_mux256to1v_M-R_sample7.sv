module Mux16to1_4bit (
    input  wire [16*4-1:0] in,  // 16 inputs, each 4-bit wide
    input  wire [3:0]      sel,
    output wire [3:0]      out
);
    // Create an array of inputs to allow direct indexing
    wire [3:0] inputs [15:0];
    genvar idx;
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : unpack_inputs
            assign inputs[idx] = in[4*idx +: 4];
        end
    endgenerate

    // Assign output by selecting the input indexed by sel
    assign out = inputs[sel];
endmodule

module Mux4to1_4bit (
    input  wire [4*4-1:0] in,  // 4 inputs, each 4-bit wide
    input  wire [1:0]     sel,
    output wire [3:0]     out
);
    wire [3:0] inputs [3:0];
    genvar idx;
    generate
        for (idx = 0; idx < 4; idx = idx + 1) begin : unpack_inputs
            assign inputs[idx] = in[4*idx +: 4];
        end
    endgenerate

    assign out = inputs[sel];
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Stage 1: 16 instances of 16-to-1 mux, each selected by sel[3:0]
    // Each mux covers 64 bits = 16 * 4 bits
    wire [3:0] stage1_out [15:0];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1
            wire [16*4-1:0] stage1_inputs;
            assign stage1_inputs = in[i*64 +: 64];
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
            // Concatenate 4 stage1 outputs into a 16-bit vector (4*4 bits)
            wire [4*4-1:0] stage2_inputs;
            assign stage2_inputs = {stage1_out[j*4 + 3], stage1_out[j*4 + 2], stage1_out[j*4 + 1], stage1_out[j*4 + 0]};
            Mux4to1_4bit mux4 (
                .in(stage2_inputs),
                .sel(sel[5:4]),
                .out(stage2_out[j])
            );
        end
    endgenerate

    // Stage 3: final 4-to-1 mux selected by sel[7:6]
    wire [4*4-1:0] stage3_inputs = {stage2_out[3], stage2_out[2], stage2_out[1], stage2_out[0]};
    Mux4to1_4bit mux4_final (
        .in(stage3_inputs),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule