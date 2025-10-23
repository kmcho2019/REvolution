module TopModule (
    input  wire [1023:0] in,    // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel,   // 8-bit select
    output wire [3:0]    out    // 4-bit output
);
    // Stage 1: Extract 16 groups of 16 inputs (each 4 bits) selected by sel[3:0]
    // Create array to hold the 16 intermediate 4-bit mux outputs
    wire [3:0] stage1_out [15:0];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_SLICE_AND_MUX
            // Slice 64 bits (16 inputs * 4 bits) for each group
            wire [63:0] group = in[i*64 +: 64];

            // Select one of the 16 4-bit inputs within the group using sel[3:0]
            assign stage1_out[i] = group[sel[3:0]*4 +: 4];
        end
    endgenerate

    // Pack the 16 stage1 outputs into a 64-bit vector for stage 2 selection
    wire [63:0] stage1_flat;
    generate
        for (i = 0; i < 16; i = i + 1) begin : PACK_STAGE1
            assign stage1_flat[i*4 +: 4] = stage1_out[i];
        end
    endgenerate

    // Stage 2: Use sel[7:4] to select the final 4-bit output from the 16 stage1 results
    assign out = stage1_flat[sel[7:4]*4 +: 4];

endmodule