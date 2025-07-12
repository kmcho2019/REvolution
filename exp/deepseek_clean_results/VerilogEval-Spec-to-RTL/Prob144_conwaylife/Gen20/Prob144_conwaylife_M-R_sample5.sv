module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function [3:0] count_neighbors;
        input [255:0] grid;
        input [7:0] idx;
        reg [3:0] row, col;
        reg [3:0] row_p, row_n, col_p, col_n;
        reg [7:0] n[0:7];
        integer i;
        begin
            row = idx / 16;
            col = idx % 16;
            
            // Calculate wrapped neighbor positions
            row_p = (row == 0) ? 15 : row - 1;
            row_n = (row == 15) ? 0 : row + 1;
            col_p = (col == 0) ? 15 : col - 1;
            col_n = (col == 15) ? 0 : col + 1;
            
            // Neighbor indices
            n[0] = row_p * 16 + col_p; // top-left
            n[1] = row_p * 16 + col;    // top
            n[2] = row_p * 16 + col_n; // top-right
            n[3] = row * 16 + col_p;    // left
            n[4] = row * 16 + col_n;    // right
            n[5] = row_n * 16 + col_p;  // bottom-left
            n[6] = row_n * 16 + col;    // bottom
            n[7] = row_n * 16 + col_n;  // bottom-right
            
            // Count live neighbors
            count_neighbors = 0;
            for (i = 0; i < 8; i = i + 1)
                count_neighbors = count_neighbors + grid[n[i]];
        end
    endfunction

    // Next state calculation
    wire [255:0] next_q;
    integer cell;
    always @(*) begin
        for (cell = 0; cell < 256; cell = cell + 1) begin
            case (count_neighbors(q, cell))
                2: next_q[cell] = q[cell];  // Stay same
                3: next_q[cell] = 1'b1;     // Become alive
                default: next_q[cell] = 1'b0; // Die
            endcase
        end
    end

    // Sequential update
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule