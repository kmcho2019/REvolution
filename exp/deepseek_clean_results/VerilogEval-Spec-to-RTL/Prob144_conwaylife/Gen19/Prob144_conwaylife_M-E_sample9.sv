module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Block-based neighbor state buffers
    reg [15:0] neighbor_state[0:15][0:15]; // [block_row][block_col]
    
    // Next state computation
    wire [255:0] next_q;
    
    // Block processing parameters
    localparam BLOCK_SIZE = 4;
    localparam NUM_BLOCKS = 4;
    
    // Pipeline registers
    reg [255:0] neighbor_counts;
    reg [255:0] stage1_q;
    
    // Generate processing blocks
    genvar block_row, block_col, i, j;
    generate
        for (block_row = 0; block_row < NUM_BLOCKS; block_row = block_row + 1) begin : row_block
            for (block_col = 0; block_col < NUM_BLOCKS; block_col = block_col + 1) begin : col_block
                // Block boundaries
                localparam [3:0] prev_row = (block_row == 0) ? NUM_BLOCKS-1 : block_row-1;
                localparam [3:0] next_row = (block_row == NUM_BLOCKS-1) ? 0 : block_row+1;
                localparam [3:0] prev_col = (block_col == 0) ? NUM_BLOCKS-1 : block_col-1;
                localparam [3:0] next_col = (block_col == NUM_BLOCKS-1) ? 0 : block_col+1;
                
                // Process each cell in block
                for (i = 0; i < BLOCK_SIZE; i = i + 1) begin : block_row_cell
                    for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : block_col_cell
                        // Global indices
                        localparam global_row = block_row*BLOCK_SIZE + i;
                        localparam global_col = block_col*BLOCK_SIZE + j;
                        localparam idx = global_row*16 + global_col;
                        
                        // Neighbor state collection (pipeline stage 1)
                        always @(posedge clk) begin
                            if (load) begin
                                neighbor_state[block_row][block_col][i*BLOCK_SIZE+j] <= 0;
                            end else begin
                                // Collect neighbor states from surrounding blocks
                                neighbor_state[block_row][block_col][i*BLOCK_SIZE+j] <= 
                                    q[((global_row-1+16)%16)*16 + ((global_col-1+16)%16)] + // NW
                                    q[((global_row-1+16)%16)*16 + global_col] +             // N
                                    q[((global_row-1+16)%16)*16 + ((global_col+1)%16)] +    // NE
                                    q[global_row*16 + ((global_col-1+16)%16)] +            // W
                                    q[global_row*16 + ((global_col+1)%16)] +               // E
                                    q[((global_row+1)%16)*16 + ((global_col-1+16)%16)] +    // SW
                                    q[((global_row+1)%16)*16 + global_col] +               // S
                                    q[((global_row+1)%16)*16 + ((global_col+1)%16)];        // SE
                            end
                        end
                        
                        // Next state calculation (pipeline stage 2)
                        always @(posedge clk) begin
                            stage1_q[idx] <= q[idx];
                            neighbor_counts[idx] <= neighbor_state[block_row][block_col][i*BLOCK_SIZE+j];
                        end
                        
                        assign next_q[idx] = (neighbor_counts[idx] == 3) ? 1'b1 :
                                           (neighbor_counts[idx] == 2) ? stage1_q[idx] :
                                           1'b0;
                    end
                end
            end
        end
    endgenerate
    
    // Main state update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule