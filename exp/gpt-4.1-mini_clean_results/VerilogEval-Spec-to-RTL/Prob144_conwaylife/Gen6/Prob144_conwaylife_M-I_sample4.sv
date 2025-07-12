module TopModule (
    input             clk,
    input             load,
    input      [255:0] data,
    output reg [255:0] q
);
    localparam WIDTH = 16;
    localparam HEIGHT = 16;

    // Internal RAM to hold current grid state: 16 rows x 16 bits each
    reg [WIDTH-1:0] grid [0:HEIGHT-1];

    // Pipeline registers for neighbor counts and next row results
    reg [3:0] neighbor_counts [0:WIDTH-1]; // 4 bits to count 0..8 neighbors per cell in current row

    reg [WIDTH-1:0] next_row; // next state for current processed row

    reg [3:0] row_idx; // 0..15 index of current row being processed

    integer c, dr, dc;
    integer nr, nc;

    // Helper function for wrapping indices modulo 16 using bitwise AND
    function [3:0] wrap16;
        input integer val;
        begin
            wrap16 = val & 4'hF;
        end
    endfunction

    // Load input data into grid rows on load
    integer r;
    always @(posedge clk) begin
        if (load) begin
            // Load each row (16 bits) from input data vector
            for (r = 0; r < HEIGHT; r = r + 1) begin
                grid[r] <= data[(r<<4) +: WIDTH];
            end
            row_idx <= 0;
            q <= data;
        end else begin
            // On each clock, process one row of the grid:
            // 1) Count neighbors for row_idx
            for (c = 0; c < WIDTH; c = c +1) begin
                integer sum;
                sum = 0;

                // Sum neighbors around (row_idx, c)
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    nr = wrap16(row_idx + dr);
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        nc = wrap16(c + dc);
                        if (!(dr == 0 && dc == 0)) begin
                            sum = sum + grid[nr][nc];
                        end
                    end
                end
                neighbor_counts[c] = sum[3:0];
            end

            // 2) Compute next state for row_idx using counts and current cell state
            for (c = 0; c < WIDTH; c = c + 1) begin
                case (neighbor_counts[c])
                    0,1: next_row[c] = 1'b0;
                    2:    next_row[c] = grid[row_idx][c];
                    3:    next_row[c] = 1'b1;
                    default: next_row[c] = 1'b0;
                endcase
            end

            // 3) Update grid row with next_row
            grid[row_idx] <= next_row;

            // 4) Update row index to process next row
            if (row_idx == HEIGHT-1) begin
                row_idx <= 0;
            end else begin
                row_idx <= row_idx + 1;
            end

            // 5) Update output q by concatenating all rows (combinationally done here by reading grid)
            // Because grid updates happen on clock edge, assign q here after updating one row
            for (r = 0; r < HEIGHT; r = r + 1) begin
                q[(r<<4) +: WIDTH] <= grid[r];
            end
        end
    end
endmodule