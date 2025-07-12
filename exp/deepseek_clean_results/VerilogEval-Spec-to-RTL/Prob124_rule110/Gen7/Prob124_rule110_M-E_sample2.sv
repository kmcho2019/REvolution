module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Parameters for hierarchical processing
    localparam BLOCK_SIZE = 8;
    localparam NUM_BLOCKS = 512/BLOCK_SIZE;
    
    // Pipeline register for intermediate results
    reg [511:0] next_q_pipeline;
    
    // Boundary cells (constant zeros)
    wire left_boundary = 1'b0;
    wire right_boundary = 1'b0;
    
    // Generate processing blocks
    genvar block;
    generate
        for (block = 0; block < NUM_BLOCKS; block = block + 1) begin : processing_blocks
            // Block boundaries
            localparam LEFT_IDX = block * BLOCK_SIZE;
            localparam RIGHT_IDX = (block + 1) * BLOCK_SIZE - 1;
            
            // Get left neighbor (from previous block or boundary)
            wire left_in = (block == 0) ? left_boundary : q[LEFT_IDX - 1];
            
            // Get right neighbor (from next block or boundary)
            wire right_in = (block == NUM_BLOCKS - 1) ? right_boundary : q[RIGHT_IDX + 1];
            
            // Process each bit in the block
            integer bit_idx;
            always @(*) begin
                for (bit_idx = 0; bit_idx < BLOCK_SIZE; bit_idx = bit_idx + 1) begin
                    // Current position in full array
                    localparam pos = LEFT_IDX + bit_idx;
                    
                    // Get neighbors
                    wire left = (bit_idx == BLOCK_SIZE - 1) ? right_in : q[pos + 1];
                    wire center = q[pos];
                    wire right = (bit_idx == 0) ? left_in : q[pos - 1];
                    
                    // Optimized Rule 110 logic
                    next_q_pipeline[pos] = left ? 
                                          ((center & right) ? 1'b0 : center ^ right) :
                                          (center | right);
                end
            end
        end
    endgenerate

    // State transition logic with pipeline stage
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            next_q_pipeline <= 512'b0; // Clear pipeline on load
        end else begin
            q <= next_q_pipeline;
            // Pipeline register feeds back to itself for next computation
            next_q_pipeline <= next_q_pipeline;
        end
    end

endmodule