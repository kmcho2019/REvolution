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
        reg [255:0] next_grid;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = i * 16 + j;
                reg [3:0] alive_neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        int neighbor_x = (i + x + 16) % 16;
                        int neighbor_y = (j + y + 16) % 16;
                        int neighbor_index = neighbor_x * 16 + neighbor_y;
                        alive_neighbors += grid[neighbor_index];
                    end
                end
                case (alive_neighbors)
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