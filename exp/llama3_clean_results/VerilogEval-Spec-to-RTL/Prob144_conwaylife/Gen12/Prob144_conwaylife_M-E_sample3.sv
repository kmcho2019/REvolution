module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

always @(*) begin
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            reg [3:0] alive_neighbors;
            NeighborCounter nc(.grid(grid),.x(i),.y(j),.alive_neighbors(alive_neighbors));
            case (alive_neighbors)
                0, 1: next_grid[i * 16 + j] = 0;
                2: next_grid[i * 16 + j] = grid[i * 16 + j];
                3: next_grid[i * 16 + j] = 1;
                default: next_grid[i * 16 + j] = 0;
            endcase
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        grid <= next_grid;
    end
    q <= grid;
end

endmodule

module NeighborCounter(
    input [255:0] grid,
    input [3:0] x,
    input [3:0] y,
    output reg [3:0] alive_neighbors
);

always @(*) begin
    alive_neighbors = 0;
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) continue;
            int index_x = (x + i + 16) % 16;
            int index_y = (y + j + 16) % 16;
            int neighbor_index = index_x + index_y * 16;
            alive_neighbors += grid[neighbor_index];
        end
    end
end

endmodule