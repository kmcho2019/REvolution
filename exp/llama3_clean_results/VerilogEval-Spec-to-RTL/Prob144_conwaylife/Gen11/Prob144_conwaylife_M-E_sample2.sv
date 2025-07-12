module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

// Function to calculate the number of alive neighbors for a cell
function [3:0] alive_neighbors;
    input [255:0] grid;
    input [7:0] row;
    input [7:0] col;

    reg [3:0] alive_neighbors_reg;
    reg [15:0] row_data;
    reg [15:0] row_above;
    reg [15:0] row_below;

    // Get the current row
    row_data = grid[(row * 16 + 15) : (row * 16)];

    // Get the row above
    if (row == 0) begin
        row_above = grid[(15 * 16 + 15) : (15 * 16)];
    end else begin
        row_above = grid[((row - 1) * 16 + 15) : ((row - 1) * 16)];
    end

    // Get the row below
    if (row == 15) begin
        row_below = grid[(0 * 16 + 15) : (0 * 16)];
    end else begin
        row_below = grid[((row + 1) * 16 + 15) : ((row + 1) * 16)];
    end

    // Calculate the number of alive neighbors
    alive_neighbors_reg = 0;

    // Top left
    if (row == 0 && col == 0) begin
        alive_neighbors_reg += (row_below[15] == 1)? 1 : 0;
    end else if (row == 0) begin
        alive_neighbors_reg += (row_below[col - 1] == 1)? 1 : 0;
    end else if (col == 0) begin
        alive_neighbors_reg += (row_above[15] == 1)? 1 : 0;
    end else begin
        alive_neighbors_reg += (row_above[col - 1] == 1)? 1 : 0;
    end

    // Top
    alive_neighbors_reg += (row_above[col] == 1)? 1 : 0;

    // Top right
    if (row == 0 && col == 15) begin
        alive_neighbors_reg += (row_below[0] == 1)? 1 : 0;
    end else if (row == 0) begin
        alive_neighbors_reg += (row_below[col + 1] == 1)? 1 : 0;
    end else if (col == 15) begin
        alive_neighbors_reg += (row_above[0] == 1)? 1 : 0;
    end else begin
        alive_neighbors_reg += (row_above[col + 1] == 1)? 1 : 0;
    end

    // Left
    alive_neighbors_reg += (row_data[col - 1] == 1)? 1 : 0;

    // Right
    alive_neighbors_reg += (row_data[col + 1] == 1)? 1 : 0;

    // Bottom left
    if (row == 15 && col == 0) begin
        alive_neighbors_reg += (row_data[15] == 1)? 1 : 0;
    end else if (row == 15) begin
        alive_neighbors_reg += (row_data[col - 1] == 1)? 1 : 0;
    end else if (col == 0) begin
        alive_neighbors_reg += (row_below[15] == 1)? 1 : 0;
    end else begin
        alive_neighbors_reg += (row_below[col - 1] == 1)? 1 : 0;
    end

    // Bottom
    alive_neighbors_reg += (row_below[col] == 1)? 1 : 0;

    // Bottom right
    if (row == 15 && col == 15) begin
        alive_neighbors_reg += (row_data[0] == 1)? 1 : 0;
    end else if (row == 15) begin
        alive_neighbors_reg += (row_data[col + 1] == 1)? 1 : 0;
    end else if (col == 15) begin
        alive_neighbors_reg += (row_below[0] == 1)? 1 : 0;
    end else begin
        alive_neighbors_reg += (row_below[col + 1] == 1)? 1 : 0;
    end

    alive_neighbors = alive_neighbors_reg;
endfunction

// Function to calculate the next state of a cell
function [0:0] next_state;
    input [0:0] current_state;
    input [3:0] alive_neighbors;

    if (current_state == 1 && (alive_neighbors == 2 || alive_neighbors == 3)) begin
        next_state = 1;
    end else if (current_state == 0 && alive_neighbors == 3) begin
        next_state = 1;
    end else begin
        next_state = 0;
    end
endfunction

// Main Game of Life logic
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = i * 16 + j;
                reg [0:0] current_state;
                current_state = grid[index];

                reg [3:0] alive_neighbors_reg;
                alive_neighbors_reg = alive_neighbors(grid, i, j);

                reg [0:0] next_state_reg;
                next_state_reg = next_state(current_state, alive_neighbors_reg);

                next_grid[index] = next_state_reg;
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule