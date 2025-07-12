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
                int index = i * 16 + j;
                int alive_neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        int neighbor_x = (i + x + 16) % 16;
                        int neighbor_y = (j + y + 16) % 16;
                        int neighbor_index = neighbor_x * 16 + neighbor_y;
                        alive_neighbors += grid[neighbor_index];
                    end
                end
                if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
                    next_grid[index] = 0;
                end else if (alive_neighbors == 2) begin
                    next_grid[index] = grid[index];
                end else begin
                    next_grid[index] = 1;
                end
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule