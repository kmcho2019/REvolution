module AliveNeighborsCounter(
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
            int index = index_x + index_y * 16;
            alive_neighbors += grid[index];
        end
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

wire [3:0] alive_neighbors [15:0][15:0];

genvar i, j;
for (genvar i = 0; i < 16; i++) begin
    for (genvar j = 0; j < 16; j++) begin
        AliveNeighborsCounter an(
           .grid(grid),
           .x(i),
           .y(j),
           .alive_neighbors(alive_neighbors[i][j])
        );
    end
end

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        reg [255:0] next_grid;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                integer index = i * 16 + j;
                case (alive_neighbors[i][j])
                    0, 1: next_grid[index] = 0;
                    2: next_grid[index] = grid[index];
                    3: next_grid[index] = 1;
                    default: next_grid[index] = 0;
                endcase
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule