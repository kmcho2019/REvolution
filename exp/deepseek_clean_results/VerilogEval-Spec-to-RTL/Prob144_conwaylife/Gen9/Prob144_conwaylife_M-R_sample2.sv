module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function [3:0] neighbor_count;
        input [255:0] grid;
        input [7:0] index;
        reg [3:0] row, col;
        reg [3:0] row_p, row_n, col_p, col_n;
        reg [7:0] neighbors;
    begin
        row = index >> 4;       // index / 16
        col = index & 15;       // index % 16
        
        // Calculate wrapped neighbor positions
        row_p = (row == 0) ? 15 : (row - 1);
        row_n = (row == 15) ? 0 : (row + 1);
        col_p = (col == 0) ? 15 : (col - 1);
        col_n = (col == 15) ? 0 : (col + 1);
        
        // Get all 8 neighbors
        neighbors[0] = grid[{row_p, col_p}];
        neighbors[1] = grid[{row_p, col}];
        neighbors[2] = grid[{row_p, col_n}];
        neighbors[3] = grid[{row, col_p}];
        neighbors[4] = grid[{row, col_n}];
        neighbors[5] = grid[{row_n, col_p}];
        neighbors[6] = grid[{row_n, col}];
        neighbors[7] = grid[{row_n, col_n}];
        
        // Count live neighbors
        neighbor_count = neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3] +
                        neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];
    end
    endfunction

    // Combinational next state calculation
    wire [255:0] next_q;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : next_state
            wire [3:0] count = neighbor_count(q, i);
            assign next_q[i] = (count == 3) ? 1'b1 :
                              (count == 2) ? q[i] :
                              1'b0;
        end
    endgenerate

    // Sequential state update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule