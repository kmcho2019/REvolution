module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Pad input to 256 bits for consistent grouping
    wire [255:0] padded_in = {in, 1'b0};

    // First level: Sum bits in groups of 4 (64 groups)
    wire [2:0] level1 [0:63];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : LEVEL1
            assign level1[i] = padded_in[i*4] + padded_in[i*4+1] + 
                              padded_in[i*4+2] + padded_in[i*4+3];
        end
    endgenerate

    // Second level: Sum level1 results in groups of 4 (16 groups)
    wire [4:0] level2 [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL2
            assign level2[i] = level1[i*4] + level1[i*4+1] + 
                              level1[i*4+2] + level1[i*4+3];
        end
    endgenerate

    // Third level: Sum level2 results in groups of 4 (4 groups)
    wire [6:0] level3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : LEVEL3
            assign level3[i] = level2[i*4] + level2[i*4+1] + 
                              level2[i*4+2] + level2[i*4+3];
        end
    endgenerate

    // Final sum
    assign out = level3[0] + level3[1] + level3[2] + level3[3];

endmodule