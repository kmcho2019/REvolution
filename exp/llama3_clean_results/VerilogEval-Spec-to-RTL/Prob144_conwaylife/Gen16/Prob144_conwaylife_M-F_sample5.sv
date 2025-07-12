// Module to count alive neighbors for a cell
module count_neighbors(
    input [255:0] grid,
    input [3:0] x,
    input [3:0] y,
    output reg [3:0] alive_neighbors
);

integer i, j, neighbor_x, neighbor_y;

always @* begin
    alive_neighbors = 0;
    for (i = -1; i <= 1; i++) begin
        for (j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) continue;
            neighbor_x = (x + i + 16) % 16;
            neighbor_y = (y + j + 16) % 16;
            alive_neighbors += grid[neighbor_x * 16 + neighbor_y];
        end
    end
end

endmodule

// Module to apply the rules of the Game of Life for a cell
module game_of_life_cell(
    input [3:0] alive_neighbors,
    input current_state,
    output reg next_state
);

always @* begin
    case (alive_neighbors)
        4'b0000, 4'b0001, 4'b1000: next_state = 1'b0;
        4'b0011: next_state = 1'b1;
        default: next_state = current_state;
    endcase
end

endmodule

// Module for the combinational logic of the Game of Life grid
module game_of_life_comb(
    input [255:0] grid,
    output reg [255:0] next_grid
);

integer i, j;
reg [3:0] alive_neighbors_reg;

always @* begin
    next_grid = grid; // Initialize next_grid with the current grid state
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            integer index = i * 16 + j;
            count_neighbors cn(.grid(grid), .x(i), .y(j), .alive_neighbors(alive_neighbors_reg));
            game_of_life_cell goc(.alive_neighbors(alive_neighbors_reg), .current_state(grid[index]), .next_state(next_grid[index]));
        end
    end
end

endmodule

// Top-level module
module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid_reg;

game_of_life_comb goc(.grid(grid), .next_grid(next_grid_reg));

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        grid <= next_grid_reg;
    end
end

assign q = grid;

endmodule