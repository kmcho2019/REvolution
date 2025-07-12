module TopModule (
    input               clk,
    input               load,
    input  [255:0]      data,
    output [255:0]      q
);
    localparam N = 16;
    localparam IDX_MASK = 4'hF;

    // Current grid state stored as 2D reg array: grid[row][col]
    reg [N-1:0] grid [0:N-1];
    reg [N-1:0] next_grid [0:N-1];

    integer r, c;

    // Flatten grid array to output vector q
    // Use generate block with continuous assign to flatten
    generate
        genvar rr, cc;
        for (rr = 0; rr < N; rr = rr + 1) begin : GEN_FLATTEN_ROW
            for (cc = 0; cc < N; cc = cc + 1) begin : GEN_FLATTEN_COL
                assign q[rr * N + cc] = grid[rr][cc];
            end
        end
    endgenerate

    // Combinational logic to compute next_grid based on current grid
    always @(*) begin
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                // Sum neighbors (8 neighbors) with wrapping using bitmask
                integer nr, nc;
                integer sum_neighbors;
                sum_neighbors = 0;

                // Loop over neighbors: dr and dc from -1 to 1, skip (0,0)
                integer dr, dc;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = (r + dr) & IDX_MASK;
                            nc = (c + dc) & IDX_MASK;
                            sum_neighbors = sum_neighbors + grid[nr][nc];
                        end
                    end
                end

                // Apply the game rules:
                // (1) 0-1 neighbor: cell=0
                // (2) 2 neighbors: cell unchanged
                // (3) 3 neighbors: cell=1
                // (4) 4+ neighbors: cell=0
                if (sum_neighbors <= 1)
                    next_grid[r][c] = 1'b0;
                else if (sum_neighbors == 2)
                    next_grid[r][c] = grid[r][c];
                else if (sum_neighbors == 3)
                    next_grid[r][c] = 1'b1;
                else
                    next_grid[r][c] = 1'b0;
            end
        end
    end

    // Sequential logic to update grid or load input data
    always @(posedge clk) begin
        if (load) begin
            // Load input data into grid 2D array
            for (r = 0; r < N; r = r + 1) begin
                grid[r] <= data[(r+1)*N-1 -: N]; // extract row slice
            end
        end else begin
            // Update grid with next state
            for (r = 0; r < N; r = r + 1) begin
                grid[r] <= next_grid[r];
            end
        end
    end

endmodule