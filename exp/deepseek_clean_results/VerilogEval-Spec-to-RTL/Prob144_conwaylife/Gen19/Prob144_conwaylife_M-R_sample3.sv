module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Represent grid as 2D array for better readability
    wire [15:0] grid [0:15];
    
    // Unpack 1D vector to 2D array
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign grid[i] = q[i*16 +: 16];
        end
    endgenerate

    // Next state computation
    wire [255:0] next_q;
    genvar row, col;
    generate
        for (row = 0; row < 16; row = row + 1) begin : row_gen
            for (col = 0; col < 16; col = col + 1) begin : col_gen
                // Calculate wrapped neighbor indices
                localparam prev_row = (row == 0) ? 15 : (row - 1);
                localparam next_row = (row == 15) ? 0 : (row + 1);
                localparam prev_col = (col == 0) ? 15 : (col - 1);
                localparam next_col = (col == 15) ? 0 : (col + 1);
                
                // Get all 8 neighbor values
                wire n0 = grid[prev_row][prev_col];
                wire n1 = grid[prev_row][col];
                wire n2 = grid[prev_row][next_col];
                wire n3 = grid[row][prev_col];
                wire n4 = grid[row][next_col];
                wire n5 = grid[next_row][prev_col];
                wire n6 = grid[next_row][col];
                wire n7 = grid[next_row][next_col];
                
                // Count neighbors using single reduction
                wire [3:0] neighbor_count = n0 + n1 + n2 + n3 + n4 + n5 + n6 + n7;
                
                // Next state logic
                assign next_q[row*16 + col] = (neighbor_count == 3) ? 1'b1 :
                                             (neighbor_count == 2) ? q[row*16 + col] :
                                             1'b0;
            end
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule