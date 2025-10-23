module AliveNeighborsCounter(
    input [255:0] grid,
    input [3:0] x,
    input [3:0] y,
    output reg [3:0] alive_neighbors
);

    assign alive_neighbors = 
        grid[((x - 1 + 16) % 16) + ((y - 1 + 16) % 16) * 16] +
        grid[((x + 16) % 16) + ((y - 1 + 16) % 16) * 16] +
        grid[((x + 1 + 16) % 16) + ((y - 1 + 16) % 16) * 16] +
        grid[((x - 1 + 16) % 16) + ((y + 16) % 16) * 16] +
        grid[((x + 16) % 16) + ((y + 16) % 16) * 16] +
        grid[((x + 1 + 16) % 16) + ((y + 16) % 16) * 16] +
        grid[((x - 1 + 16) % 16) + ((y + 1 + 16) % 16) * 16] +
        grid[((x + 16) % 16) + ((y + 1 + 16) % 16) * 16] +
        grid[((x + 1 + 16) % 16) + ((y + 1 + 16) % 16) * 16];

endmodule

module GameLogic(
    input [255:0] grid,
    output reg [255:0] next_grid
);

reg [3:0] alive_neighbors;
reg [3:0] x, y;

integer i;
always @(*) begin
    for (i = 0; i < 256; i++) begin
        x = i % 16;
        y = i / 16;
        AliveNeighborsCounter counter(
            .grid(grid),
            .x(x),
            .y(y),
            .alive_neighbors(alive_neighbors)
        );
        case (alive_neighbors)
            0, 1: next_grid[i] = 0;
            2: next_grid[i] = grid[i];
            3: next_grid[i] = 1;
            default: next_grid[i] = 0;
        endcase
    end
end

endmodule

module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

GameLogic game_logic(
    .grid(grid),
    .next_grid(next_grid)
);

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        grid <= next_grid;
    end
    q <= grid;
end

endmodule