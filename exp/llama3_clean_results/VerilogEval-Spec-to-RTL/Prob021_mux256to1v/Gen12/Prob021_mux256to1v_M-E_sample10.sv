module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Define the number of levels in the tree
localparam NUM_LEVELS = 8;

// Define the width of each level
localparam LEVEL_WIDTH = 4;

// Define the total number of nodes in the tree
localparam NUM_NODES = 2 ** NUM_LEVELS;

// Create an array to store the 4-bit inputs
wire [3:0] inputs [255:0];
genvar i;
for (i = 0; i < 256; i++) begin
    assign inputs[i] = in[(i * 4) +: 4];
end

// Create a hierarchical selection process using 2-to-1 multiplexers
wire [3:0] level1 [127:0];
for (i = 0; i < 128; i++) begin
    assign level1[i] = (sel[0] == 0) ? inputs[i * 2] : inputs[i * 2 + 1];
end

wire [3:0] level2 [63:0];
for (i = 0; i < 64; i++) begin
    assign level2[i] = (sel[1] == 0) ? level1[i * 2] : level1[i * 2 + 1];
end

wire [3:0] level3 [31:0];
for (i = 0; i < 32; i++) begin
    assign level3[i] = (sel[2] == 0) ? level2[i * 2] : level2[i * 2 + 1];
end

wire [3:0] level4 [15:0];
for (i = 0; i < 16; i++) begin
    assign level4[i] = (sel[3] == 0) ? level3[i * 2] : level3[i * 2 + 1];
end

wire [3:0] level5 [7:0];
for (i = 0; i < 8; i++) begin
    assign level5[i] = (sel[4] == 0) ? level4[i * 2] : level4[i * 2 + 1];
end

wire [3:0] level6 [3:0];
for (i = 0; i < 4; i++) begin
    assign level6[i] = (sel[5] == 0) ? level5[i * 2] : level5[i * 2 + 1];
end

wire [3:0] level7 [1:0];
for (i = 0; i < 2; i++) begin
    assign level7[i] = (sel[6] == 0) ? level6[i * 2] : level6[i * 2 + 1];
end

// Select the final output
assign out = (sel[7] == 0) ? level7[0] : level7[1];

endmodule