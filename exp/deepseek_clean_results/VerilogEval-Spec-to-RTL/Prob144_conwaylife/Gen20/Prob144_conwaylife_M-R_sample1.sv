module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function [3:0] count_neighbors;
        input [255:0] grid;
        input [3:0] row, col;
        reg [3:0] row_p, row_n, col_p, col_n;
        reg [15:0] row_above, row_below, row_curr;
        begin
            // Calculate wrapped neighbor indices
            row_p = row - 4'd1;
            row_n = row + 4'd1;
            col_p = col - 4'd1;
            col_n = col + 4'd1;
            
            // Extract relevant rows
            row_above = grid[row_p*16 +: 16];
            row_curr = grid[row*16 +: 16];
            row_below = grid[row_n*16 +: 16];
            
            // Count neighbors using bit selection
            count_neighbors = 
                row_above[col_p] + row_above[col] + row_above[col_n] +
                row_curr[col_p] + row_curr[col_n] +
                row_below[col_p] + row_below[col] + row_below[col_n];
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (integer row = 0; row < 16; row = row + 1) begin
                for (integer col = 0; col < 16; col = col + 1) begin
                    reg [3:0] neighbors = count_neighbors(q, row[3:0], col[3:0]);
                    case (neighbors)
                        2: q[row*16 + col] <= q[row*16 + col]; // No change
                        3: q[row*16 + col] <= 1'b1;
                        default: q[row*16 + col] <= 1'b0;
                    endcase
                end
            end
        end
    end

endmodule