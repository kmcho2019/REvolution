module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

// Parameters for block division
parameter BLOCK_SIZE = 16;
parameter NUM_BLOCKS = 512 / BLOCK_SIZE;

// Generate blocks
genvar block_idx;
generate
    for (block_idx = 0; block_idx < NUM_BLOCKS; block_idx++) begin
        // Calculate block boundaries
        wire [BLOCK_SIZE-1:0] left_boundary;
        wire [BLOCK_SIZE-1:0] right_boundary;
        if (block_idx == 0) begin
            assign left_boundary = {BLOCK_SIZE{1'b0}}; // Left boundary of first block
        end else begin
            assign left_boundary = q_reg[(block_idx-1)*BLOCK_SIZE +: BLOCK_SIZE]; // Left boundary of other blocks
        end
        if (block_idx == NUM_BLOCKS-1) begin
            assign right_boundary = {BLOCK_SIZE{1'b0}}; // Right boundary of last block
        end else begin
            assign right_boundary = q_reg[(block_idx+1)*BLOCK_SIZE +: BLOCK_SIZE]; // Right boundary of other blocks
        end
        
        // Compute next state for each block
        wire [BLOCK_SIZE-1:0] next_state;
        genvar cell_idx;
        generate
            for (cell_idx = 0; cell_idx < BLOCK_SIZE; cell_idx++) begin
                wire left, center, right;
                if (cell_idx == 0) begin
                    assign left = left_boundary[0]; // Left boundary of block
                    assign center = q_reg[block_idx*BLOCK_SIZE + cell_idx];
                    assign right = q_reg[block_idx*BLOCK_SIZE + cell_idx + 1];
                end else if (cell_idx == BLOCK_SIZE-1) begin
                    assign left = q_reg[block_idx*BLOCK_SIZE + cell_idx - 1];
                    assign center = q_reg[block_idx*BLOCK_SIZE + cell_idx];
                    assign right = right_boundary[0]; // Right boundary of block
                end else begin
                    assign left = q_reg[block_idx*BLOCK_SIZE + cell_idx - 1];
                    assign center = q_reg[block_idx*BLOCK_SIZE + cell_idx];
                    assign right = q_reg[block_idx*BLOCK_SIZE + cell_idx + 1];
                end
                assign next_state[cell_idx] = left ^ right; // Rule 90: XOR of left and right
            end
        endgenerate
        
        // Update q_reg for each block
        always @(posedge clk) begin
            if (load) begin
                q_reg[block_idx*BLOCK_SIZE +: BLOCK_SIZE] <= data[block_idx*BLOCK_SIZE +: BLOCK_SIZE]; // Load input data
            end else begin
                q_reg[block_idx*BLOCK_SIZE +: BLOCK_SIZE] <= next_state; // Update with calculated next states
            end
        end
    end
endgenerate

assign q = q_reg; // Output the current state

endmodule