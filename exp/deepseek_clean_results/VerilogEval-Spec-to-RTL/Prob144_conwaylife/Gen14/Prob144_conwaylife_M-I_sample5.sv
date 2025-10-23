module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Precompute row sums for neighbor counting
    wire [15:0] row_sums [0:15];
    genvar row;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_sum
            assign row_sums[row] = q[row*16 +: 16];
        end
    endgenerate

    // Next state calculation with optimized neighbor counting
    wire [255:0] next_q;
    wire [63:0] block_stable;  // Clock gating for 4x4 blocks
    
    genvar i, j;
    generate
        for (i = 0; i < 4; i = i + 1) begin : block_row
            for (j = 0; j < 4; j = j + 1) begin : block_col
                // Track if any cell in 4x4 block will change
                wire any_change = 0;
                
                for (integer sub_i = 0; sub_i < 4; sub_i = sub_i + 1) begin : cell_row
                    for (integer sub_j = 0; sub_j < 4; sub_j = sub_j + 1) begin : cell_col
                        integer cell_row = i*4 + sub_i;
                        integer cell_col = j*4 + sub_j;
                        
                        // Calculate neighbor positions with optimized wrap-around
                        integer row_prev = (cell_row == 0) ? 15 : cell_row - 1;
                        integer row_next = (cell_row == 15) ? 0 : cell_row + 1;
                        integer col_prev = (cell_col == 0) ? 15 : cell_col - 1;
                        integer col_next = (cell_col == 15) ? 0 : cell_col + 1;
                        
                        // Wallace tree neighbor count (8 inputs)
                        wire [3:0] neighbor_count = 
                            row_sums[row_prev][col_prev] + row_sums[row_prev][cell_col] + row_sums[row_prev][col_next] +
                            row_sums[cell_row][col_prev] + row_sums[cell_row][col_next] +
                            row_sums[row_next][col_prev] + row_sums[row_next][cell_col] + row_sums[row_next][col_next];
                        
                        // Next state calculation
                        wire cell_next = (neighbor_count == 3) ? 1'b1 : 
                                        (neighbor_count == 2) ? q[cell_row*16 + cell_col] : 1'b0;
                        
                        assign next_q[cell_row*16 + cell_col] = cell_next;
                        assign any_change = any_change | (cell_next != q[cell_row*16 + cell_col]);
                    end
                end
                
                assign block_stable[i*4 + j] = ~any_change;
            end
        end
    endgenerate

    // Hierarchical clock-gated sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only blocks with changes
            for (integer i = 0; i < 4; i = i + 1) begin
                for (integer j = 0; j < 4; j = j + 1) begin
                    if (!block_stable[i*4 + j]) begin
                        for (integer sub_i = 0; sub_i < 4; sub_i = sub_i + 1) begin
                            for (integer sub_j = 0; sub_j < 4; sub_j = sub_j + 1) begin
                                integer cell_row = i*4 + sub_i;
                                integer cell_col = j*4 + sub_j;
                                q[cell_row*16 + cell_col] <= next_q[cell_row*16 + cell_col];
                            end
                        end
                    end
                end
            end
        end
    end

endmodule