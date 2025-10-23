module Mux4to1_4bit (
    input  wire [4*4-1:0] in,  // 4 inputs, each 4-bit wide (16 bits)
    input  wire [1:0]     sel,
    output wire [3:0]     out
);
    // Select 4-bit slice indexed by sel
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,  // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel, // 8-bit selector
    output wire [3:0]    out
);

    // Stage 1: 256 inputs grouped into 64 groups of 4 inputs each
    // Each mux selects 4 inputs, each 4 bits wide => 16 bits per mux input bus
    wire [3:0] stage1_out [0:63];

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE1
            wire [15:0] in_slice;
            // Extract 4 consecutive 4-bit inputs: 4*4=16 bits per group
            assign in_slice = in[i*16 +: 16];
            Mux4to1_4bit mux_inst (
                .in(in_slice),
                .sel(sel[1:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 64 stage1 outputs grouped into 16 groups of 4
    wire [3:0] stage2_out [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE2
            wire [15:0] in_slice;
            // Concatenate 4 stage1 outputs (4*4 bits =16 bits)
            assign in_slice = {
                stage1_out[i*4 + 3],
                stage1_out[i*4 + 2],
                stage1_out[i*4 + 1],
                stage1_out[i*4 + 0]
            };
            Mux4to1_4bit mux_inst (
                .in(in_slice),
                .sel(sel[3:2]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    // Stage 3: 16 stage2 outputs grouped into 4 groups of 4
    wire [3:0] stage3_out [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE3
            wire [15:0] in_slice;
            // Concatenate 4 stage2 outputs (4*4 bits =16 bits)
            assign in_slice = {
                stage2_out[i*4 + 3],
                stage2_out[i*4 + 2],
                stage2_out[i*4 + 1],
                stage2_out[i*4 + 0]
            };
            Mux4to1_4bit mux_inst (
                .in(in_slice),
                .sel(sel[5:4]),
                .out(stage3_out[i])
            );
        end
    endgenerate

    // Stage 4: final mux selects among 4 stage3 outputs
    wire [15:0] final_in;
    assign final_in = {
        stage3_out[3],
        stage3_out[2],
        stage3_out[1],
        stage3_out[0]
    };

    Mux4to1_4bit final_mux (
        .in(final_in),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule