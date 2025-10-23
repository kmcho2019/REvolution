module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // 2D grid representation of current state
    reg grid [0:N-1][0:N-1];

    // Temporary next state grid
    reg next_grid [0:N-1][0:N-1];

    integer r, c;
    integer rp, rn; // row previous, row next indices with wrap
    integer cp, cn; // column previous, next indices with wrap
    integer dr, dc; // delta row, delta column

    // Unpack q to grid on load or on reset (initially zero)
    always @(posedge clk) begin
        if (load) begin
            // Load input data vector into grid
            for (r = 0; r < N; r = r + 1) begin
                for (c = 0; c < N; c = c + 1) begin
                    grid[r][c] <= data[r*16 + c];
                end
            end
        end else begin
            // Advance game by one timestep
            for (r = 0; r < N; r = r + 1) begin
                rp = (r == 0) ? N - 1 : r - 1;
                rn = (r == N - 1) ? 0 : r + 1;
                for (c = 0; c < N; c = c + 1) begin
                    cp = (c == 0) ? N - 1 : c - 1;
                    cn = (c == N - 1) ? 0 : c + 1;
                    // Sum of 8 neighbors
                    integer sum_neighbors;
                    sum_neighbors =
                        grid[rp][cp] + grid[rp][c] + grid[rp][cn] +
                        grid[r][cp]               + grid[r][cn] +
                        grid[rn][cp] + grid[rn][c] + grid[rn][cn];
                    // Apply rules
                    if (sum_neighbors <= 1)
                        next_grid[r][c] <= 1'b0;
                    else if (sum_neighbors == 2)
                        next_grid[r][c] <= grid[r][c];
                    else if (sum_neighbors == 3)
                        next_grid[r][c] <= 1'b1;
                    else
                        next_grid[r][c] <= 1'b0;
                end
            end
            // Update grid from next_grid
            for (r = 0; r < N; r = r + 1) begin
                for (c = 0; c < N; c = c + 1) begin
                    grid[r][c] <= next_grid[r][c];
                end
            end
        end
    end

    // Pack grid into output vector q combinationally
    always @(*) begin
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                q[r*16 + c] = grid[r][c];
            end
        end
    end

endmodule