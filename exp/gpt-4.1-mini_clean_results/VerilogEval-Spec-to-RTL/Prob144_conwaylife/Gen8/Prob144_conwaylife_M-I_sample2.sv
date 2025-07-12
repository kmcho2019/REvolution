module TopModule (
    input              clk,
    input              load,
    input      [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = 4'hF; // for modulo 16 wrap-around

    // 16 rows of 16 bits representing the grid state
    reg [SIZE-1:0] grid [0:SIZE-1];
    reg [SIZE-1:0] next_grid [0:SIZE-1];

    reg [3:0] row_idx; // index of current row being computed
    integer c, ni, nj;
    reg [3:0] neighbor_count;
    reg current_cell;
    reg [3:0] r, c_idx, nr, nc;

    // Convert flat input data to 2D grid array for load operation
    integer i;
    always @(posedge clk) begin
        if (load) begin
            for (i = 0; i < SIZE; i = i + 1)
                grid[i] <= data[(i+1)*SIZE-1 -: SIZE];
            row_idx <= 0;
            q <= data; // output updated immediately with loaded data
        end else begin
            // Compute next state for row `row_idx`
            for (c = 0; c < SIZE; c = c + 1) begin
                r = row_idx;
                c_idx = c;
                neighbor_count = 0;
                current_cell = grid[r][c_idx];

                // Sum neighbors over 3x3 window excluding center cell
                for (ni = -1; ni <= 1; ni = ni + 1) begin
                    for (nj = -1; nj <= 1; nj = nj + 1) begin
                        if (!(ni == 0 && nj == 0)) begin
                            // Wrap row and column indices modulo 16 by masking 4 bits
                            nr = (r + ni) & MASK;
                            nc = (c_idx + nj) & MASK;
                            neighbor_count = neighbor_count + grid[nr][nc];
                        end
                    end
                end

                // Apply rules:
                // 0-1 neighbor => 0
                // 2 neighbors => unchanged
                // 3 neighbors => 1
                // 4+ neighbors => 0
                case (neighbor_count)
                    4'd2: next_grid[r][c_idx] <= current_cell;
                    4'd3: next_grid[r][c_idx] <= 1'b1;
                    default: next_grid[r][c_idx] <= 1'b0;
                endcase
            end

            // Move to next row or update grid and output q when done
            if (row_idx == SIZE - 1) begin
                // After last row computed, update grid and output
                for (i = 0; i < SIZE; i = i + 1) begin
                    grid[i] <= next_grid[i];
                end
                // Update output q concatenating rows (row0 LSB)
                q <= {
                    grid[15], grid[14], grid[13], grid[12],
                    grid[11], grid[10], grid[9], grid[8],
                    grid[7], grid[6], grid[5], grid[4],
                    grid[3], grid[2], grid[1], grid[0]
                };
                row_idx <= 0;
            end else begin
                row_idx <= row_idx + 1;
            end
        end
    end

endmodule