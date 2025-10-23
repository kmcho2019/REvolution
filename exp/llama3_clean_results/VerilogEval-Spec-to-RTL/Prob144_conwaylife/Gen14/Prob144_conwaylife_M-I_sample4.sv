module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

// Function to calculate the number of alive neighbors for a given cell
function integer count_neighbors(input [255:0] grid, input integer x, input integer y);
    integer alive_neighbors;
    integer i, j, neighbor_x, neighbor_y;
    alive_neighbors = 0;
    for (i = -1; i <= 1; i++) begin
        for (j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) continue;
            neighbor_x = (x + i + 16) % 16;
            neighbor_y = (y + j + 16) % 16;
            alive_neighbors += grid[neighbor_x * 16 + neighbor_y];
        end
    end
    return alive_neighbors;
endfunction

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
    for (integer i = 0; i < 16; i++) begin
        for (integer j = 0; j < 16; j++) begin
            integer index = i * 16 + j;
            integer alive_neighbors = count_neighbors(grid, i, j);
            if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
                next_grid[index] = 1'b0;
            end else if (alive_neighbors == 3) begin
                next_grid[index] = 1'b1;
            end else begin
                // For 2 alive neighbors, the cell's state does not change
                // This is handled implicitly by the initial assignment next_grid = grid;
            end
        end
    end
end

// Assign output q directly from grid
assign q = grid;

endmodule