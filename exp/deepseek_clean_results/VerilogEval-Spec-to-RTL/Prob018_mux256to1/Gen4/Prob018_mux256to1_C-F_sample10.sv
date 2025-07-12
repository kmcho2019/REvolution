module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // One-hot decode upper 5 bits (for stages 1 and 2)
    wire [31:0] sel_oh1 = (1 << sel[7:3]);
    wire [7:0] sel_oh2 = (1 << sel[2:0]);

    // Stage 1: 32 groups of 8-to-1 muxes (only enabled ones active)
    wire [31:0] stage1_out;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : stage1
            assign stage1_out[i] = sel_oh1[i] ? in[(i*8) + sel[2:0]] : 1'b0;
        end
    endgenerate

    // Stage 2: 4 groups of 8-to-1 muxes (only enabled ones active)
    wire [7:0] stage2_out;
    genvar j;
    generate
        for (j = 0; j < 8; j = j + 1) begin : stage2
            assign stage2_out[j] = sel_oh2[j] ? |(stage1_out & (32'hFF << (j*8))) : 1'b0;
        end
    endgenerate

    // Final stage: simple 4-to-1 mux
    assign out = stage2_out[sel[1:0]];

endmodule