module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function [3:0] count_neighbors;
        input [255:0] grid;
        input [7:0] index;
        reg [3:0] row, col;
        reg [3:0] row_p, row_n, col_p, col_n;
        begin
            row = index[7:4];
            col = index[3:0];
            
            // Compute wrapped neighbor indices
            row_p = (row == 0) ? 15 : row - 1;
            row_n = (row == 15) ? 0 : row + 1;
            col_p = (col == 0) ? 15 : col - 1;
            col_n = (col == 15) ? 0 : col + 1;
            
            // Count all 8 neighbors
            count_neighbors = 
                grid[{row_p, col_p}] + grid[{row_p, col}] + grid[{row_p, col_n}] +
                grid[{row,  col_p}] +                      grid[{row,  col_n}] +
                grid[{row_n,col_p}] + grid[{row_n,col}] + grid[{row_n,col_n}];
        end
    endfunction

    wire [255:0] next_state;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell
            wire [3:0] neighbors = count_neighbors(q, i);
            assign next_state[i] = (neighbors == 3) || (neighbors == 2 && q[i]);
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule