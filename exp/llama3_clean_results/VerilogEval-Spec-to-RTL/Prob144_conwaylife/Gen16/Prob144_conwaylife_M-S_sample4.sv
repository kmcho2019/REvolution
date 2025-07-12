module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

integer i, j, k, x, y, nx, ny, alive;

// Sequential logic to handle loading and clocking
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        grid <= next_grid;
    end
end

// Combinational logic to compute the next grid state
always @* begin
    next_grid = grid; // Initialize next_grid with the current grid state
    for (i = 0; i < 256; i++) begin
        x = i / 16; // Current cell's x-coordinate
        y = i % 16; // Current cell's y-coordinate
        alive = 0; // Count of alive neighbors
        for (j = -1; j <= 1; j++) begin
            for (k = -1; k <= 1; k++) begin
                if (j == 0 && k == 0) continue; // Skip the current cell
                nx = (x + j + 16) % 16; // Neighbor's x-coordinate
                ny = (y + k + 16) % 16; // Neighbor's y-coordinate
                alive += grid[nx * 16 + ny]; // Count alive neighbors
            end
        end
        // Simplified game logic
        if (alive == 3 || (alive == 2 && grid[i] == 1'b1)) begin
            next_grid[i] = 1'b1;
        end else begin
            next_grid[i] = 1'b0;
        end
    end
end

// Assign output q directly from grid
assign q = grid;

endmodule