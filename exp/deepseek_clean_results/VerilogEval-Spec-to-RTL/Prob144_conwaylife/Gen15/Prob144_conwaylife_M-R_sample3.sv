module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to count neighbors for a given cell
    function [3:0] count_neighbors;
        input [255:0] grid;
        input [7:0] idx;
        reg [3:0] row, col;
        reg [3:0] row_p, row_n, col_p, col_n;
        begin
            // Calculate current position
            row = idx / 16;
            col = idx % 16;
            
            // Calculate neighbor positions with wrap-around
            row_p = (row == 0) ? 15 : row - 1;
            row_n = (row == 15) ? 0 : row + 1;
            col_p = (col == 0) ? 15 : col - 1;
            col_n = (col == 15) ? 0 : col + 1;
            
            // Sum all 8 neighbors
            count_neighbors = 
                grid[row_p*16 + col_p] + grid[row_p*16 + col] + grid[row_p*16 + col_n] +
                grid[row*16 + col_p]                          + grid[row*16 + col_n] +
                grid[row_n*16 + col_p] + grid[row_n*16 + col] + grid[row_n*16 + col_n];
        end
    endfunction

    // Next state calculation
    wire [255:0] next_q;
    integer i;
    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            case (count_neighbors(q, i))
                2: next_q[i] = q[i];    // Maintain state
                3: next_q[i] = 1'b1;    // Become alive
                default: next_q[i] = 1'b0; // Die
            endcase
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