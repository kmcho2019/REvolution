module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Represent grid as 2D array for clarity
    wire [15:0] grid [0:15];
    
    // Unpack 1D vector to 2D array
    genvar r;
    generate
        for (r = 0; r < 16; r = r + 1) begin : unpack
            assign grid[r] = q[r*16 +: 16];
        end
    endgenerate

    // Next state calculation
    reg [255:0] next_q;
    integer row, col;
    always @(*) begin
        for (row = 0; row < 16; row = row + 1) begin
            for (col = 0; col < 16; col = col + 1) begin
                // Calculate neighbor positions with wrap-around
                wire [3:0] row_p = (row == 0) ? 15 : (row - 1);
                wire [3:0] row_n = (row == 15) ? 0 : (row + 1);
                wire [3:0] col_p = (col == 0) ? 15 : (col - 1);
                wire [3:0] col_n = (col == 15) ? 0 : (col + 1);
                
                // Count live neighbors
                wire [3:0] count = 
                    grid[row_p][col_p] + grid[row_p][col] + grid[row_p][col_n] +
                    grid[row][col_p]                     + grid[row][col_n] +
                    grid[row_n][col_p] + grid[row_n][col] + grid[row_n][col_n];
                
                // Determine next state
                next_q[row*16 + col] = (count == 3) ? 1'b1 :
                                       (count == 2) ? q[row*16 + col] :
                                       1'b0;
            end
        end
    end

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule