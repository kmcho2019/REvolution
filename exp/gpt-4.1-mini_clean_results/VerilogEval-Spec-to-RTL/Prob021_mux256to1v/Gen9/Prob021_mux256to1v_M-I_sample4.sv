module Mux4to1_4bit (
    input  [4*4-1:0] in,  // 4 inputs, each 4-bit wide (16 bits)
    input  [1:0]     sel,
    output [3:0]     out
);
    // Select 4-bit slice indexed by sel
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Stage 1: 256 inputs grouped in 64 groups of 4 inputs (each 4-bit)
    // Each Mux4to1_4bit selects among 4 inputs
    wire [3:0] stage1_out [0:63];

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE1
            wire [15:0] in_slice;
            // Each group of 4 inputs * 4 bits = 16 bits
            assign in_slice = in[i*16 +: 16];
            Mux4to1_4bit mux4to1_1 (
                .in(in_slice),
                .sel(sel[1:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 64 inputs from stage1 grouped in 16 groups of 4 inputs
    wire [3:0] stage2_out [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE2
            wire [15:0] in_slice;
            // Concatenate 4 stage1 outputs (4*4=16 bits)
            assign in_slice = {
                stage1_out[i*4+3],
                stage1_out[i*4+2],
                stage1_out[i*4+1],
                stage1_out[i*4+0]
            };
            Mux4to1_4bit mux4to1_2 (
                .in(in_slice),
                .sel(sel[3:2]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    // Stage 3: 16 inputs from stage2 grouped in 4 groups of 4 inputs
    wire [3:0] stage3_out [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE3
            wire [15:0] in_slice;
            // Concatenate 4 stage2 outputs (4*4=16 bits)
            assign in_slice = {
                stage2_out[i*4+3],
                stage2_out[i*4+2],
                stage2_out[i*4+1],
                stage2_out[i*4+0]
            };
            Mux4to1_4bit mux4to1_3 (
                .in(in_slice),
                .sel(sel[5:4]),
                .out(stage3_out[i])
            );
        end
    endgenerate

    // Stage 4: 4 inputs from stage3, final mux
    wire [15:0] final_in;
    assign final_in = {
        stage3_out[3],
        stage3_out[2],
        stage3_out[1],
        stage3_out[0]
    };

    Mux4to1_4bit mux4to1_final (
        .in(final_in),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule