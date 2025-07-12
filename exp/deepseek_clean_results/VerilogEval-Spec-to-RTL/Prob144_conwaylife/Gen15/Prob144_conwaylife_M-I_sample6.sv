module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipelined neighbor counting with shared resources
    reg [255:0] q_ff;
    wire [255:0] next_q;
    wire [63:0] block_stable;  // 4x4 block stability indicators
    
    // Precompute row sums for neighbor counting
    wire [15:0][15:0] row_sums;
    generate
        for (genvar row = 0; row < 16; row = row + 1) begin
            assign row_sums[row] = q[row*16 +: 16];
        end
    endgenerate

    // Process in 4x4 blocks for resource sharing
    genvar block_row, block_col;
    generate
        for (block_row = 0; block_row < 4; block_row = block_row + 1) begin : block_row_loop
            for (block_col = 0; block_col < 4; block_col = block_col + 1) begin : block_col_loop
                // Block stability (if all cells in block have 2 neighbors)
                wire block_stable = 1'b1;
                
                for (genvar i = 0; i < 4; i = i + 1) begin : cell_row
                    for (genvar j = 0; j < 4; j = j + 1) begin : cell_col
                        // Calculate absolute cell position
                        localparam row = block_row*4 + i;
                        localparam col = block_col*4 + j;
                        
                        // Neighbor positions with wrap-around (using bit selection)
                        wire [3:0] row_p = row - 1;
                        wire [3:0] row_n = row + 1;
                        wire [3:0] col_p = col - 1;
                        wire [3:0] col_n = col + 1;
                        
                        // Get neighbor values
                        wire nw = q[{row_p,col_p}];
                        wire n  = q[{row_p,col}];
                        wire ne = q[{row_p,col_n}];
                        wire w  = q[{row,col_p}];
                        wire e  = q[{row,col_n}];
                        wire sw = q[{row_n,col_p}];
                        wire s  = q[{row_n,col}];
                        wire se = q[{row_n,col_n}];
                        
                        // Carry-save adder for neighbor count
                        wire [1:0] sum1 = nw + n + ne;
                        wire [1:0] sum2 = w + e;
                        wire [1:0] sum3 = sw + s + se;
                        wire [3:0] neighbor_count = sum1 + sum2 + sum3;
                        
                        // Cell stability affects block stability
                        wire cell_stable = (neighbor_count == 4'd2);
                        if (i == 0 && j == 0) begin
                            assign block_stable[block_row*4 + block_col] = cell_stable;
                        end else begin
                            assign block_stable[block_row*4 + block_col] = 
                                block_stable[block_row*4 + block_col] & cell_stable;
                        end
                        
                        // Next state calculation
                        assign next_q[row*16 + col] = cell_stable ? q[row*16 + col] :
                                                    (neighbor_count == 4'd3) ? 1'b1 : 1'b0;
                    end
                end
            end
        end
    endgenerate

    // Clock-gated sequential update (block-based)
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only non-stable blocks
            for (integer br = 0; br < 4; br = br + 1) begin
                for (integer bc = 0; bc < 4; bc = bc + 1) begin
                    if (!block_stable[br*4 + bc]) begin
                        for (integer i = 0; i < 4; i = i + 1) begin
                            for (integer j = 0; j < 4; j = j + 1) begin
                                integer row = br*4 + i;
                                integer col = bc*4 + j;
                                q[row*16 + col] <= next_q[row*16 + col];
                            end
                        end
                    end
                end
            end
        end
    end

endmodule