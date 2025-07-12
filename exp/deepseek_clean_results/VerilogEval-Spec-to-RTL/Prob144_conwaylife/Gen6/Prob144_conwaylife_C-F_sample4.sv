module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    wire [63:0] block_stable;  // Clock gating for 4x4 blocks (16x16 grid -> 4x4 blocks)

    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            for (col = 0; col < 16; col = col + 1) begin : col_loop
                // Calculate neighbor positions with bit masking (16 is 2^4)
                wire [3:0] row_prev = row - 4'b1;
                wire [3:0] row_next = row + 4'b1;
                wire [3:0] col_prev = col - 4'b1;
                wire [3:0] col_next = col + 4'b1;
                
                // Neighbor count using optimized adder structure
                wire [1:0] sum1 = q[{row_prev, col_prev}] + q[{row_prev, col}] + 
                                 q[{row_prev, col_next}];
                wire [1:0] sum2 = q[{row, col_prev}] + q[{row, col_next}];
                wire [1:0] sum3 = q[{row_next, col_prev}] + q[{row_next, col}] + 
                                 q[{row_next, col_next}];
                wire [3:0] neighbor_count = sum1 + sum2 + sum3;
                
                // Next state logic with early termination
                assign next_q[{row,col}] = (neighbor_count == 3) ? 1'b1 :
                                         (neighbor_count == 2) ? q[{row,col}] :
                                         1'b0;
            end
        end
        
        // Generate block stability signals (4x4 blocks)
        for (row = 0; row < 4; row = row + 1) begin : block_row
            for (col = 0; col < 4; col = col + 1) begin : block_col
                // Check if all 16 cells in this block are stable
                wire [15:0] cell_stable;
                for (integer i = 0; i < 4; i = i + 1) begin
                    for (integer j = 0; j < 4; j = j + 1) begin
                        localparam idx = (row*4+i)*16 + (col*4+j);
                        assign cell_stable[i*4+j] = (q[idx] == next_q[idx]);
                    end
                end
                assign block_stable[row*4 + col] = &cell_stable;
            end
        end
    endgenerate

    // Clock-gated sequential update at block level
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer block = 0; block < 16; block = block + 1) begin
                if (!block_stable[block]) begin
                    for (integer i = 0; i < 4; i = i + 1) begin
                        for (integer j = 0; j < 4; j = j + 1) begin
                            integer idx = (block/4*4 + i)*16 + (block%4*4 + j);
                            q[idx] <= next_q[idx];
                        end
                    end
                end
            end
        end
    end

endmodule