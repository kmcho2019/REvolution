module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Precompute row sums for neighbor counting
    wire [15:0] row_sums [15:0];
    genvar row;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_sum
            assign row_sums[row] = q[row*16 +: 16];
        end
    endgenerate

    // Next state calculation with optimized neighbor counting
    wire [255:0] next_q;
    wire [63:0] block_stable;  // Clock gating for 4x4 blocks
    
    genvar block_row, block_col;
    generate
        for (block_row = 0; block_row < 4; block_row = block_row + 1) begin : block_row_loop
            for (block_col = 0; block_col < 4; block_col = block_col + 1) begin : block_col_loop
                reg [15:0] block_stable_flags;
                
                // Calculate stability for each 4x4 block
                always @(*) begin
                    block_stable_flags = 16'hFFFF;
                    for (integer r = 0; r < 4; r = r + 1) begin
                        for (integer c = 0; c < 4; c = c + 1) begin
                            integer abs_row = block_row*4 + r;
                            integer abs_col = block_col*4 + c;
                            
                            // Calculate neighbor positions with optimized wrap-around
                            integer row_prev = (abs_row == 0) ? 15 : abs_row - 1;
                            integer row_next = (abs_row == 15) ? 0 : abs_row + 1;
                            integer col_prev = (abs_col == 0) ? 15 : abs_col - 1;
                            integer col_next = (abs_col == 15) ? 0 : abs_col + 1;
                            
                            // Efficient neighbor count using precomputed row sums
                            wire [3:0] neighbor_count = 
                                row_sums[row_prev][col_prev] + row_sums[row_prev][abs_col] + row_sums[row_prev][col_next] +
                                row_sums[abs_row][col_prev] + row_sums[abs_row][col_next] +
                                row_sums[row_next][col_prev] + row_sums[row_next][abs_col] + row_sums[row_next][col_next];
                            
                            // Next state calculation
                            assign next_q[abs_row*16 + abs_col] = 
                                (neighbor_count == 4'd2) ? q[abs_row*16 + abs_col] :
                                (neighbor_count == 4'd3) ? 1'b1 : 1'b0;
                                
                            // Update stability flag
                            if (neighbor_count != 4'd2) begin
                                block_stable_flags[r*4 + c] = 1'b0;
                            end
                        end
                    end
                end
                
                assign block_stable[block_row*4 + block_col] = (block_stable_flags == 16'hFFFF);
            end
        end
    endgenerate

    // Clock-gated sequential update (block-based)
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer block = 0; block < 16; block = block + 1) begin
                if (!block_stable[block]) begin
                    integer block_row = block / 4;
                    integer block_col = block % 4;
                    
                    for (integer r = 0; r < 4; r = r + 1) begin
                        for (integer c = 0; c < 4; c = c + 1) begin
                            integer abs_row = block_row*4 + r;
                            integer abs_col = block_col*4 + c;
                            q[abs_row*16 + abs_col] <= next_q[abs_row*16 + abs_col];
                        end
                    end
                end
            end
        end
    end

endmodule