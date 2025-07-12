module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Define the number of blocks and cells per block
localparam NUM_BLOCKS = 16;
localparam CELLS_PER_BLOCK = 32;

// Define the block structure
wire [NUM_BLOCKS-1:0][CELLS_PER_BLOCK-1:0] next_state;

// Generate the blocks
genvar i;
generate
    for (i = 0; i < NUM_BLOCKS; i++) begin
        // Define the block boundaries
        localparam BLOCK_START = i * CELLS_PER_BLOCK;
        localparam BLOCK_END = (i + 1) * CELLS_PER_BLOCK - 1;

        // Compute the next state of each cell in the block
        wire [CELLS_PER_BLOCK-1:0] block_next_state;
        wire [CELLS_PER_BLOCK-1:0] block_q_reg;

        // Assign the current state of each cell in the block
        assign block_q_reg = q_reg[BLOCK_END:BLOCK_START];

        // Compute the next state of each cell in the block
        genvar j;
        generate
            for (j = 0; j < CELLS_PER_BLOCK; j++) begin
                wire left, center, right;
                // Simplified boundary conditions
                assign left = (i == 0 && j == 0) ? 1'b0 : (j == 0) ? q_reg[BLOCK_START - 1] : block_q_reg[j - 1];
                assign center = block_q_reg[j];
                assign right = (i == NUM_BLOCKS - 1 && j == CELLS_PER_BLOCK - 1) ? 1'b0 : (j == CELLS_PER_BLOCK - 1) ? q_reg[BLOCK_END + 1] : block_q_reg[j + 1];

                // Apply Rule 90 logic directly without needing additional variables
                assign block_next_state[j] = (left == 1 && center == 1 && right == 1) ? 1'b0 :
                                             (left == 1 && center == 1 && right == 0) ? 1'b1 :
                                             (left == 1 && center == 0 && right == 1) ? 1'b0 :
                                             (left == 1 && center == 0 && right == 0) ? 1'b1 :
                                             (left == 0 && center == 1 && right == 1) ? 1'b1 :
                                             (left == 0 && center == 1 && right == 0) ? 1'b0 :
                                             (left == 0 && center == 0 && right == 1) ? 1'b1 :
                                             (left == 0 && center == 0 && right == 0) ? 1'b0 : 1'b0;
            end
        endgenerate

        // Assign the next state of each block
        assign next_state[i] = block_next_state;
    end
endgenerate

// Sequential logic to update q_reg on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Update q_reg with the next state of each block
        reg [NUM_BLOCKS-1:0][CELLS_PER_BLOCK-1:0] temp;
        temp = next_state;
        q_reg <= {temp[NUM_BLOCKS-1:0]};
    end
end

assign q = q_reg;

endmodule