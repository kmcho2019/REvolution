module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);
    localparam SIZE = 16;
    localparam MASK = SIZE - 1;

    reg [0:SIZE-1] grid [0:SIZE-1]; // current state as 2D reg array
    reg [0:SIZE-1] next_grid [0:SIZE-1];
    integer r, c, dr, dc, nr, nc, neighbors;

    // Unpack q into grid on load or state update on clk
    always @(posedge clk) begin
        if (load) begin
            for (r = 0; r < SIZE; r = r + 1)
                for (c = 0; c < SIZE; c = c + 1)
                    grid[r][c] <= data[r*SIZE + c];
        end else begin
            for (r = 0; r < SIZE; r = r + 1)
                for (c = 0; c < SIZE; c = c + 1)
                    grid[r][c] <= next_grid[r][c];
        end
    end

    // Combinational logic to compute next state
    always @* begin
        for (r = 0; r < SIZE; r = r + 1) begin
            for (c = 0; c < SIZE; c = c + 1) begin
                neighbors = 0;
                for (dr = -1; dr <= 1; dr = dr + 1) begin
                    for (dc = -1; dc <= 1; dc = dc + 1) begin
                        if (!(dr == 0 && dc == 0)) begin
                            nr = (r + dr) & MASK; // wrap row
                            nc = (c + dc) & MASK; // wrap col
                            neighbors = neighbors + grid[nr][nc];
                        end
                    end
                end
                // Apply rules
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

    // Pack grid back into q
    always @* begin
        for (r = 0; r < SIZE; r = r + 1)
            for (c = 0; c < SIZE; c = c + 1)
                q[r*SIZE + c] = grid[r][c];
    end

endmodule