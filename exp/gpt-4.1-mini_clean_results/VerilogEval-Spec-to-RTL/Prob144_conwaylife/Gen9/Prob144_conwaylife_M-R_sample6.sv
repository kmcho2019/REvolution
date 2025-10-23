module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam N = 16;

    // Internal 2D array representation of current state and next state
    reg grid [0:N-1][0:N-1];
    reg next_grid [0:N-1][0:N-1];

    integer r, c;

    // Unpack q into grid at every clock to ease computation (synchronous)
    always @(posedge clk) begin
        if (load) begin
            // Load initial data into grid
            for (r = 0; r < N; r = r + 1) begin
                for (c = 0; c < N; c = c + 1) begin
                    grid[r][c] <= data[r*16 + c];
                end
            end
        end else begin
            // Update grid with computed next state
            for (r = 0; r < N; r = r + 1) begin
                for (c = 0; c < N; c = c + 1) begin
                    grid[r][c] <= next_grid[r][c];
                end
            end
        end
    end

    // Compute next state combinationally
    always @(*) begin
        // Helper function: modular wrapping for indices
        function integer wrap;
            input integer idx;
            begin
                if (idx < 0)
                    wrap = idx + N;
                else if (idx >= N)
                    wrap = idx - N;
                else
                    wrap = idx;
            end
        endfunction

        integer rr, cc;
        integer neighbors;

        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                neighbors = 0;
                // Sum 8 neighbors with wrap-around
                for (rr = -1; rr <= 1; rr = rr + 1) begin
                    for (cc = -1; cc <= 1; cc = cc + 1) begin
                        if (!(rr == 0 && cc == 0)) begin
                            neighbors = neighbors + grid[wrap(r + rr)][wrap(c + cc)];
                        end
                    end
                end

                // Apply rules:
                // 0-1 neighbor -> 0
                // 2 neighbors -> state unchanged
                // 3 neighbors -> 1
                // 4+ neighbors -> 0
                if (neighbors <= 1)
                    next_grid[r][c] = 1'b0;
                else if (neighbors == 2)
                    next_grid[r][c] = grid[r][c];
                else if (neighbors == 3)
                    next_grid[r][c] = 1'b1;
                else
                    next_grid[r][c] = 1'b0;
            end
        end
    end

    // Flatten grid to output q
    always @(*) begin
        for (r = 0; r < N; r = r + 1) begin
            for (c = 0; c < N; c = c + 1) begin
                q[r*16 + c] = grid[r][c];
            end
        end
    end

endmodule