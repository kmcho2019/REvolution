module GameOfLife(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

// Module to calculate the number of alive neighbors for each cell
module AliveNeighbors(
    input [15:0] cell,
    input [255:0] grid,
    output [3:0] alive_neighbors
);

reg [3:0] alive_neighbors_reg;

always @(*) begin
    alive_neighbors_reg = 0;
    for (int i = 0; i < 16; i++) begin
        if (cell[i] == 1) begin
            alive_neighbors_reg += 1;
        end
    end
    alive_neighbors = alive_neighbors_reg;
end

endmodule

// Module to calculate the next state of a 4x4 block
module Block(
    input [15:0] cell,
    input [255:0] grid,
    output reg [15:0] next_cell
);

reg [15:0] next_cell_reg;
reg [3:0] alive_neighbors;

AliveNeighbors alive_neighbors_module(
    .cell(cell),
    .grid(grid),
    .alive_neighbors(alive_neighbors)
);

always @(*) begin
    next_cell_reg = 0;
    for (int i = 0; i < 16; i++) begin
        if (alive_neighbors == 2 || alive_neighbors == 3) begin
            next_cell_reg[i] = 1;
        end else if (alive_neighbors < 2 || alive_neighbors > 3) begin
            next_cell_reg[i] = 0;
        end
    end
    next_cell = next_cell_reg;
end

endmodule

// Main Game of Life module
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = i * 16 + j;
                reg [15:0] cell;
                cell = grid[(i*16 + 15) : (i*16)];
                Block block_module(
                    .cell(cell),
                    .grid(grid),
                    .next_cell(next_grid[(i*16 + 15) : (i*16)])
                );
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule