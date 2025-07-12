module Mux4to1_4bit (
    input  [4*4-1:0] in, // 4 inputs, each 4-bit wide
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
    // Level 1: 64 muxes of 4-to-1, each selects among 4 4-bit inputs from 'in'
    wire [3:0] level1_out [0:63];

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : LEVEL1
            // Each selects from 4 consecutive 4-bit inputs: total 16 bits per mux
            // Start bit offset in 'in': i*16 (4 inputs * 4 bits)
            wire [15:0] in_slice;
            assign in_slice = in[i*16 +: 16];
            Mux4to1_4bit mux4to1_l1 (
                .in(in_slice),
                .sel(sel[1:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Level 2: 16 muxes of 4-to-1, select among 4 level1 outputs each
    wire [3:0] level2_out [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL2
            // Concatenate 4 level1 outputs of 4 bits each = 16 bits input to mux
            wire [15:0] in_slice;
            assign in_slice = { level1_out[i*4+3], level1_out[i*4+2], level1_out[i*4+1], level1_out[i*4] };
            // Note: ordering reversed because {a,b,c,d} concatenates a as MSB chunk
            // To keep index 0 as lowest, we concatenate in order: [3],[2],[1],[0]

            Mux4to1_4bit mux4to1_l2 (
                .in(in_slice),
                .sel(sel[3:2]),
                .out(level2_out[i])
            );
        end
    endgenerate

    // Level 3: 4 muxes of 4-to-1, select among 4 level2 outputs each
    wire [3:0] level3_out [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL3
            wire [15:0] in_slice;
            assign in_slice = { level2_out[i*4+3], level2_out[i*4+2], level2_out[i*4+1], level2_out[i*4] };
            Mux4to1_4bit mux4to1_l3 (
                .in(in_slice),
                .sel(sel[5:4]),
                .out(level3_out[i])
            );
        end
    endgenerate

    // Level 4: Final mux of 4-to-1, selects among level3 outputs
    wire [15:0] in_final;
    assign in_final = { level3_out[3], level3_out[2], level3_out[1], level3_out[0] };

    Mux4to1_4bit mux4to1_final (
        .in(in_final),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule