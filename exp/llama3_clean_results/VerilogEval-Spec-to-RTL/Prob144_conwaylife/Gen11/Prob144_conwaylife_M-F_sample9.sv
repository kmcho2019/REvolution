module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [7:0] alive_neighbors;
                alive_neighbors = 8'b0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        wire [3:0] neighbor_x;
                        wire [3:0] neighbor_y;
                        wire [7:0] neighbor_index;
                        neighbor_x = (i + x + 16) % 16;
                        neighbor_y = (j + y + 16) % 16;
                        neighbor_index = neighbor_x * 16 + neighbor_y;
                        alive_neighbors = alive_neighbors + grid[neighbor_index];
                    end
                end
                if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
                    next_grid[i * 16 + j] <= 1'b0;
                end else if (alive_neighbors == 2) begin
                    next_grid[i * 16 + j] <= grid[i * 16 + j];
                end else begin
                    next_grid[i * 16 + j] <= 1'b1;
                end
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule