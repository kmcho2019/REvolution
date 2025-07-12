module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    // Level 0: 64 groups of 4 bits selected by sel[1:0]
    wire [63:0] level0_out;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : LEVEL0
            assign level0_out[i] = in[i*4 + sel[1:0]];
        end
    endgenerate

    // Level 1: 16 groups of 4 bits selected from level0_out by sel[3:2]
    wire [15:0] level1_out;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1
            assign level1_out[i] = level0_out[i*4 + sel[3:2]];
        end
    endgenerate

    // Level 2: 4 groups of 4 bits selected from level1_out by sel[5:4]
    wire [3:0] level2_out;
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL2
            assign level2_out[i] = level1_out[i*4 + sel[5:4]];
        end
    endgenerate

    // Level 3: final 4-to-1 mux selecting from level2_out by sel[7:6]
    assign out = level2_out[sel[7:6]];

endmodule