module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Block-based clock gating signals
    wire [15:0] block_stable;
    wire [255:0] next_q;
    
    // Precompute row sums for neighbor counting
    wire [15:0][3:0] row_sums_prev, row_sums_curr, row_sums_next;
    
    genvar row, col;
    generate
        // Precompute row sums (shared between columns)
        for (row = 0; row < 16; row = row + 1) begin : row_sum
            wire [3:0] row_p = row - 1;
            wire [3:0] row_n = row + 1;
            
            // Sum of previous row (3 cells)
            assign row_sums_prev[row] = q[row_p*16 + ((col-1)&15)] + 
                                       q[row_p*16 + col] + 
                                       q[row_p*16 + ((col+1)&15)];
            
            // Sum of current row (2 cells - excluding self)
            assign row_sums_curr[row] = q[row*16 + ((col-1)&15)] + 
                                       q[row*16 + ((col+1)&15)];
            
            // Sum of next row (3 cells)
            assign row_sums_next[row] = q[row_n*16 + ((col-1)&15)] + 
                                       q[row_n*16 + col] + 
                                       q[row_n*16 + ((col+1)&15)];
        end

        // Process each 4x4 block
        for (row = 0; row < 16; row = row + 4) begin : block_row
            for (col = 0; col < 16; col = col + 4) begin : block_col
                // Block stability (OR of all cell stability signals)
                wire block_unstable = 0;
                
                // Process each cell in the 4x4 block
                for (int i = 0; i < 4; i = i + 1) begin : cell_row
                    for (int j = 0; j < 4; j = j + 1) begin : cell_col
                        wire [3:0] abs_row = row + i;
                        wire [3:0] abs_col = col + j;
                        
                        // Neighbor count using precomputed row sums
                        wire [3:0] neighbor_count = 
                            row_sums_prev[abs_row] + 
                            row_sums_curr[abs_row] + 
                            row_sums_next[abs_row];
                        
                        // Next state calculation
                        wire cell_next = (neighbor_count == 3) ? 1'b1 :
                                        (neighbor_count == 2) ? q[abs_row*16 + abs_col] : 
                                        1'b0;
                        
                        assign next_q[abs_row*16 + abs_col] = cell_next;
                        assign block_unstable = block_unstable | 
                                               (neighbor_count != 3'd2);
                    end
                end
                
                assign block_stable[(row/4)*4 + (col/4)] = ~block_unstable;
            end
        end
    endgenerate

    // Clock-gated sequential update (4x4 block granularity)
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (int block = 0; block < 16; block = block + 1) begin
                if (!block_stable[block]) begin
                    for (int i = 0; i < 4; i = i + 1) begin
                        for (int j = 0; j < 4; j = j + 1) begin
                            int row = (block/4)*4 + i;
                            int col = (block%4)*4 + j;
                            q[row*16 + col] <= next_q[row*16 + col];
                        end
                    end
                end
            end
        end
    end

endmodule