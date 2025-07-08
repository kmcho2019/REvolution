module TopModule (
    input wire clk,
    input wire load,
    input wire [255:0] data,
    output reg [255:0] q
);

    // Internal 2D representation of the grid for easier neighbor calculation
    reg grid [0:15][0:15];
    reg next_grid [0:15][0:15];

    integer r, c, rr, cc;

    // Unpack q into grid on every clock for neighbor calculation
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                grid[r][c] = q[r*16 + c];
            end
        end
    end

    // Compute next state combinationally
    always @(*) begin
        for (r = 0; r < 16; r = r + 1) begin
            for (c = 0; c < 16; c = c + 1) begin
                // Count neighbors with wrap-around
                integer neighbors;
                neighbors = 0;

                for (rr = -1; rr <= 1; rr = rr + 1) begin
                    for (cc = -1; cc <= 1; cc = cc + 1) begin
                        if (!(rr == 0 && cc == 0)) begin
                            // Wrap indices modulo 16
                            integer nr = (r + rr + 16) % 16;
                            integer nc = (c + cc + 16) % 16;
                            neighbors = neighbors + grid[nr][nc];
                        end
                    end
                end

                // Apply game rules
                if      (neighbors <= 1) next_grid[r][c] = 1'b0;               // 0-1 neighbors -> dead
                else if (neighbors == 2) next_grid[r][c] = grid[r][c];        // 2 neighbors -> same state
                else if (neighbors == 3) next_grid[r][c] = 1'b1;              // 3 neighbors -> alive
                else                     next_grid[r][c] = 1'b0;              // 4+ neighbors -> dead
            end
        end
    end

    // Sequential logic: on clock edge, either load data or update q with next_grid
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Pack next_grid into q
            for (r = 0; r < 16; r = r + 1) begin
                for (c = 0; c < 16; c = c + 1) begin
                    q[r*16 + c] <= next_grid[r][c];
                end
            end
        end
    end

endmodule