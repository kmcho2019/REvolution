module AliveNeighborsCounter(
    input [15:0] x,
    input [15:0] y,
    input [255:0] grid,
    output reg [3:0] alive_neighbors
);

always @(x or y or grid) begin
    alive_neighbors = 0;
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) continue;
            int index_x = (x + i + 16) % 16;
            int index_y = (y + j + 16) % 16;
            int index = index_x * 16 + index_y;
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

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (int i = 0; i < 256; i++) begin
            integer x = i / 16;
            integer y = i % 16;
            reg [3:0] alive_neighbors;
            AliveNeighborsCounter counter(.x(x), .y(y), .grid(grid), .alive_neighbors(alive_neighbors));
            case (alive_neighbors)
                0, 1: q[i] <= 0;
                2: q[i] <= grid[i];
                3: q[i] <= 1;
                default: q[i] <= 0;
            endcase
            grid[i] <= q[i];
        end
    end
end

endmodule