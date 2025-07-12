module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Define the block size
parameter BLOCK_SIZE = 16;

// Define the number of blocks
parameter NUM_BLOCKS = 512 / BLOCK_SIZE;

reg [BLOCK_SIZE-1:0] block_regs [NUM_BLOCKS-1:0];

// Combinational logic to calculate the next state of each block
wire [BLOCK_SIZE-1:0] next_block;

genvar i;
generate
    for (i = 0; i < NUM_BLOCKS; i++) begin
        wire [BLOCK_SIZE-1:0] left, center, right;
        // Boundary conditions
        if (i == 0) begin
            assign left = {BLOCK_SIZE{1'b0}};
            assign center = block_regs[i];
            assign right = (i == NUM_BLOCKS-1)? {BLOCK_SIZE{1'b0}} : block_regs[i + 1][BLOCK_SIZE-1:BLOCK_SIZE-1];
        end else if (i == NUM_BLOCKS-1) begin
            assign left = block_regs[i - 1][0:0];
            assign center = block_regs[i];
            assign right = {BLOCK_SIZE{1'b0}};
        end else begin
            assign left = block_regs[i - 1][0:0];
            assign center = block_regs[i];
            assign right = block_regs[i + 1][BLOCK_SIZE-1:BLOCK_SIZE-1];
        end
        // Apply Rule 90 logic
        wire [BLOCK_SIZE-1:0] next_block_temp;
        for (int j = 0; j < BLOCK_SIZE; j++) begin
            assign next_block_temp[j] = (j == 0)? (left[0] ^ right[0]) : (center[j-1] ^ right[j]);
        end
        assign next_block = next_block_temp;
        // Register the next block
        always @(posedge clk) begin
            if (load) begin
                block_regs[i] <= data[(i*BLOCK_SIZE + BLOCK_SIZE - 1) : (i*BLOCK_SIZE)];
            end else begin
                block_regs[i] <= next_block;
            end
        end
    end
endgenerate

// Output logic
assign q = {block_regs[NUM_BLOCKS-1], block_regs[NUM_BLOCKS-2], ..., block_regs[0]};

endmodule