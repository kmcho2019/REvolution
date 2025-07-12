module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

integer i, j, x, y, index, neighbor_x, neighbor_y, neighbor_index;
integer alive_neighbors;

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
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            index = i * 16 + j;
            alive_neighbors = 0;
            for (x = -1; x <= 1; x++) begin
                for (y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;
                    neighbor_x = (i + x + 16) % 16;
                    neighbor_y = (j + y + 16) % 16;
                    neighbor_index = neighbor_x * 16 + neighbor_y;
                    alive_neighbors += grid[neighbor_index];
                end
            end
            // Simplified game logic
            if (alive_neighbors == 3 || (alive_neighbors == 2 && grid[index] == 1'b1)) begin
                next_grid[index] = 1'b1;
            end else begin
                next_grid[index] = 1'b0;
            end
        end
    end
end

// Assign output q directly from grid
assign q = grid;

endmodule