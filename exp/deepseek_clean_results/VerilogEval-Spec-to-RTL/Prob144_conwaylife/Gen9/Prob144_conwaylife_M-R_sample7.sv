module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to count live neighbors for a given cell
    function [3:0] count_neighbors;
        input [255:0] grid;
        input [7:0] index;
        reg [3:0] row, col;
        reg [3:0] row_p, row_n, col_p, col_n;
        begin
            row = index / 16;
            col = index % 16;
            
            // Calculate wrapped neighbor positions
            row_p = (row == 0) ? 15 : (row - 1);
            row_n = (row == 15) ? 0 : (row + 1);
            col_p = (col == 0) ? 15 : (col - 1);
            col_n = (col == 15) ? 0 : (col + 1);
            
            // Sum all 8 neighbors
            count_neighbors = 
                grid[row_p*16 + col_p] +  // top-left
                grid[row_p*16 + col] +    // top
                grid[row_p*16 + col_n] +  // top-right
                grid[row*16 + col_p] +    // left
                grid[row*16 + col_n] +    // right
                grid[row_n*16 + col_p] +  // bottom-left
                grid[row_n*16 + col] +    // bottom
                grid[row_n*16 + col_n];   // bottom-right
        end
    endfunction

    // Calculate next state for each cell
    wire [255:0] next_q;
    generate
        genvar i;
        for (i = 0; i < 256; i = i + 1) begin : next_state
            wire [3:0] neighbors = count_neighbors(q, i);
            assign next_q[i] = (neighbors == 3) ? 1'b1 :
                              (neighbors == 2) ? q[i] :
                              1'b0;
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