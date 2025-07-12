module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Divide the 255-bit input into 64 chunks of 4 bits (with 1 bit left over)
    wire [3:0] chunk [63:0];
    wire [3:0] leftover;

    // Assign the input bits to the chunks
    genvar i;
    generate
        for (i = 0; i < 64; i++) begin
            assign chunk[i] = in[4*i + 3 : 4*i];
        end
        assign leftover = in[255 : 254];
    endgenerate

    // Count the number of '1's in each chunk
    wire [3:0] count [63:0];
    wire [3:0] leftover_count;

    genvar j;
    generate
        for (j = 0; j < 64; j++) begin
            assign count[j] = {chunk[j][3] + chunk[j][2] + chunk[j][1] + chunk[j][0], 3'b0};
        end
        assign leftover_count = {leftover[0], 3'b0};
    endgenerate

    // Add up the counts in a tree-like structure
    wire [7:0] level1 [31:0];
    wire [7:0] level2 [15:0];
    wire [7:0] level3 [7:0];
    wire [7:0] level4 [3:0];
    wire [7:0] level5 [1:0];
    wire [7:0] level6;

    generate
        for (i = 0; i < 32; i++) begin
            assign level1[i] = (i < 31) ? count[2*i] + count[2*i+1] : count[2*i] + leftover_count;
        end
    endgenerate

    generate
        for (i = 0; i < 16; i++) begin
            assign level2[i] = level1[2*i] + level1[2*i+1];
        end
    endgenerate

    generate
        for (i = 0; i < 8; i++) begin
            assign level3[i] = level2[2*i] + level2[2*i+1];
        end
    endgenerate

    generate
        for (i = 0; i < 4; i++) begin
            assign level4[i] = level3[2*i] + level3[2*i+1];
        end
    endgenerate

    generate
        for (i = 0; i < 2; i++) begin
            assign level5[i] = level4[2*i] + level4[2*i+1];
        end
    endgenerate

    assign level6 = level5[0] + level5[1];

    assign out = level6;

endmodule