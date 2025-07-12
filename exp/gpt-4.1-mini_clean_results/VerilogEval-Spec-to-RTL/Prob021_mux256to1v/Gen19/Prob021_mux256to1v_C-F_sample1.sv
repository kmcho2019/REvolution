module Mux16to1_4bit (
    input  wire [16*4-1:0] in,  // 16 inputs, 4 bits each packed
    input  wire [3:0]      sel,
    output wire [3:0]      out
);
    // Directly select 4-bit slice using arithmetic indexing
    assign out = in[sel*4 +: 4];
endmodule

module Mux4to1_4bit (
    input  wire [4*4-1:0] in,  // 4 inputs, 4 bits each packed
    input  wire [1:0]     sel,
    output wire [3:0]     out
);
    // Directly select 4-bit slice using arithmetic indexing
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,   // 256 inputs x 4 bits
    input  wire [7:0]    sel,  // selects one of 256 inputs
    output wire [3:0]    out
);

    // Stage 1: 16 instances of 16-to-1 muxes, each handling 64 bits = 16*4 bits
    // Each mux is selected by sel[3:0]
    wire [3:0] stage1_out [15:0];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : stage1
            // Slice 64 bits for each 16-to-1 mux
            wire [16*4-1:0] stage1_inputs = in[i*64 +: 64];
            Mux16to1_4bit mux16to1_inst (
                .in(stage1_inputs),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 4 instances of 4-to-1 muxes, selected by sel[5:4]
    wire [3:0] stage2_out [3:0];
    genvar j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : stage2
            // Concatenate 4 stage1 outputs into a packed 16-bit vector (4*4 bits)
            wire [4*4-1:0] stage2_inputs = {
                stage1_out[j*4 + 3],
                stage1_out[j*4 + 2],
                stage1_out[j*4 + 1],
                stage1_out[j*4 + 0]
            };
            Mux4to1_4bit mux4to1_stage2_inst (
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

    Mux4to1_4bit mux4to1_final (
        .in(stage3_inputs),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule