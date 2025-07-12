module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // First stage outputs: 16 4-bit mux outputs (one per 64-bit block)
    wire [3:0] stage1_out [15:0];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_stage1
            // Extract 64-bit block corresponding to i (16 4-bit inputs)
            wire [63:0] block = in[i*64 +: 64];
            // Select among 16 4-bit inputs inside this block using sel[3:0]
            assign stage1_out[i] = block[sel[3:0]*4 +: 4];
        end
    endgenerate

    // Second stage: select among 16 stage1 outputs using sel[7:4]
    assign out = stage1_out[sel[7:4]];

endmodule