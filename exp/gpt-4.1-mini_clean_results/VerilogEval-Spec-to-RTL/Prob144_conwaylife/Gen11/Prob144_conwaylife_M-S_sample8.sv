module TopModule (
    input             clk,
    input             load,
    input      [255:0] data,
    output reg [255:0] q
);

    localparam SIZE = 16;
    localparam MASK = 4'hF;

    reg grid [0:SIZE-1][0:SIZE-1];
    reg next_grid [0:SIZE-1][0:SIZE-1];

    integer r, c;

    // Convert flat input data to 2D grid
    always @(posedge clk) begin
        if (load) begin
            for (r = 0; r < SIZE; r = r + 1) begin
                for (c = 0; c < SIZE; c = c + 1) begin
                    grid[r][c] <= data[r*SIZE + c];
                end
            end
        end else begin
            // Compute next state for each cell
            for (r = 0; r < SIZE; r = r + 1) begin
                for (c = 0; c < SIZE; c = c + 1) begin
                    // Count live neighbors with wrap-around
                    integer rr, cc, count;
                    count = 0;
                    for (rr = r-1; rr <= r+1; rr = rr + 1) begin
                        for (cc = c-1; cc <= c+1; cc = cc + 1) begin
                            if (!((rr == r) && (cc == c))) begin
                                count = count + grid[rr & MASK][cc & MASK];
                            end
                        end
                    end

                    // Apply game rules
                    if (count == 3)
                        next_grid[r][c] = 1'b1;
                    else if (count == 2)
                        next_grid[r][c] = grid[r][c];
                    else
                        next_grid[r][c] = 1'b0;
                end
            end

            // Update grid to next state
            for (r = 0; r < SIZE; r = r + 1) begin
                for (c = 0; c < SIZE; c = c + 1) begin
                    grid[r][c] <= next_grid[r][c];
                end
            end
        end
    end

    // Flatten 2D grid to output q
    always @(*) begin
        for (r = 0; r < SIZE; r = r + 1) begin
            for (c = 0; c < SIZE; c = c + 1) begin
                q[r*SIZE + c] = grid[r][c];
            end
        end
    end

endmodule