module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Precompute row sums for neighbor counting
    wire [255:0] row_sums;
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_sum
            for (col = 0; col < 16; col = col + 1) begin : col_sum
                // Sum of current row's left and right neighbors
                assign row_sums[row*16 + col] = q[row*16 + ((col-1)&15)] + 
                                              q[row*16 + ((col+1)&15)];
            end
        end
    endgenerate

    // Next state calculation with optimized neighbor counting
    wire [255:0] next_q;
    wire [63:0] block_enable;  // Enable signals for 4x4 blocks
    
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_logic
            for (col = 0; col < 16; col = col + 1) begin : col_logic
                // Get previous and next rows (with wrap-around)
                wire [255:0] prev_row = q[((row-1)&15)*16 +: 256];
                wire [255:0] next_row = q[((row+1)&15)*16 +: 256];
                
                // Neighbor count from adjacent rows (optimized tree adder)
                wire [2:0] top_sum = prev_row[((col-1)&15)] + prev_row[col] + prev_row[((col+1)&15)];
                wire [2:0] bottom_sum = next_row[((col-1)&15)] + next_row[col] + next_row[((col+1)&15)];
                wire [2:0] neighbor_count = top_sum + bottom_sum + row_sums[row*16 + col];
                
                // Stability detection (2 neighbors)
                wire cell_stable = (neighbor_count == 3'd2);
                
                // Block enable (for hierarchical clock gating)
                if (row%4 == 0 && col%4 == 0) begin
                    assign block_enable[(row/4)*4 + (col/4)] = |{
                        !cell_stable, !q[row*16 + col + 1] != next_q[row*16 + col + 1],
                        !q[row*16 + col + 16] != next_q[row*16 + col + 16],
                        !q[row*16 + col + 17] != next_q[row*16 + col + 17]
                    };
                end
                
                // Optimized next state calculation
                assign next_q[row*16 + col] = cell_stable ? q[row*16 + col] :
                                            (neighbor_count == 3'd3) ? 1'b1 : 1'b0;
            end
        end
    endgenerate

    // Hierarchically clock-gated sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only blocks with changing cells
            for (integer i = 0; i < 16; i = i + 1) begin
                for (integer j = 0; j < 16; j = j + 1) begin
                    if (block_enable[(i/4)*4 + (j/4)]) begin
                        q[i*16 + j] <= next_q[i*16 + j];
                    end
                end
            end
        end
    end

endmodule