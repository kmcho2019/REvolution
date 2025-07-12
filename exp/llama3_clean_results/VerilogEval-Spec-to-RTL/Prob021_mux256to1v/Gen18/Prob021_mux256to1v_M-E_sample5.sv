module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Define the number of levels in the binary tree
localparam NUM_LEVELS = 8;

// Define the width of each level
localparam LEVEL_WIDTH = 4;

// Create an array to store the outputs of each level
wire [LEVEL_WIDTH-1:0] level_out [NUM_LEVELS-1:0];

// Create the binary tree structure
genvar i;
for (i = 0; i < NUM_LEVELS; i++) begin
    if (i == 0) begin
        // Level 0: split the input vector into 256 blocks of 4 bits each
        for (genvar j = 0; j < 256; j++) begin
            assign level_out[i][j*LEVEL_WIDTH +: LEVEL_WIDTH] = in[j*LEVEL_WIDTH +: LEVEL_WIDTH];
        end
    end else begin
        // Levels 1-7: create 2-to-1 multiplexers
        for (genvar j = 0; j < 2**(8-i); j++) begin
            assign level_out[i][j*LEVEL_WIDTH +: LEVEL_WIDTH] = (sel[i-1] == 0)? level_out[i-1][j*2*LEVEL_WIDTH +: LEVEL_WIDTH] : level_out[i-1][j*2*LEVEL_WIDTH + LEVEL_WIDTH +: LEVEL_WIDTH];
        end
    end
end

// Assign the output of the final level to the out port
assign out = level_out[NUM_LEVELS-1];

endmodule