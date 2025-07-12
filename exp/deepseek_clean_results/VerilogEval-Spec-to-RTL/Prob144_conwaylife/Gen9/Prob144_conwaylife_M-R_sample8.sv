module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Represent grid as 2D array for clarity
    wire [15:0] grid [0:15];
    
    // Flatten the grid for output
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign grid[i] = q[i*16 +: 16];
        end
    endgenerate

    // Next state calculation
    wire [255:0] next_q;
    
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_loop
            for (col = 0; col < 16; col = col + 1) begin : col_loop
                // Calculate wrapped neighbor indices
                localparam [3:0] prev_row = (row == 0) ? 15 : (row - 1);
                localparam [3:0] next_row = (row == 15) ? 0 : (row + 1);
                localparam [3:0] prev_col = (col == 0) ? 15 : (col - 1);
                localparam [3:0] next_col = (col == 15) ? 0 : (col + 1);
                
                // Get all 8 neighbor values
                wire n0 = grid[prev_row][prev_col];  // top-left
                wire n1 = grid[prev_row][col];       // top
                wire n2 = grid[prev_row][next_col];  // top-right
                wire n3 = grid[row][prev_col];       // left
                wire n4 = grid[row][next_col];       // right
                wire n5 = grid[next_row][prev_col];  // bottom-left
                wire n6 = grid[next_row][col];       // bottom
                wire n7 = grid[next_row][next_col];  // bottom-right
                
                // Balanced adder tree for neighbor count
                wire [1:0] sum_a = n0 + n1 + n2 + n3;
                wire [1:0] sum_b = n4 + n5 + n6 + n7;
                wire [3:0] neighbor_count = sum_a + sum_b;
                
                // Next state logic
                assign next_q[row*16 + col] = (neighbor_count == 3) ? 1'b1 :
                                             (neighbor_count == 2) ? q[row*16 + col] :
                                             1'b0;
            end
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule