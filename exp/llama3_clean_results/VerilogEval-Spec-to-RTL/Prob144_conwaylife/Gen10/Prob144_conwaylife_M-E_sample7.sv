module AliveNeighborsCounter(
    input [255:0] grid,
    output [255:0] alive_neighbors
);

reg [3:0] neighbors [15:0][15:0];

integer i, j, x, y;
always @(*) begin
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            neighbors[i][j] = 0;
            for (x = -1; x <= 1; x++) begin
                for (y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;
                    integer index_x = (i + x + 16) % 16;
                    integer index_y = (j + y + 16) % 16;
                    integer index = index_x + index_y * 16;
                    neighbors[i][j] += grid[index];
                end
            end
        end
    end
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            integer index = i * 16 + j;
            alive_neighbors[index] = neighbors[i][j];
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
reg [255:0] next_grid;

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        reg [255:0] alive_neighbors;
        for (integer i = 0; i < 16; i++) begin
            for (integer j = 0; j < 16; j++) begin
                integer index = i * 16 + j;
                integer neighbors = 0;
                for (integer x = -1; x <= 1; x++) begin
                    for (integer y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        integer index_x = (i + x + 16) % 16;
                        integer index_y = (j + y + 16) % 16;
                        integer neighbor_index = index_x + index_y * 16;
                        neighbors += grid[neighbor_index];
                    end
                end
                case (neighbors)
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