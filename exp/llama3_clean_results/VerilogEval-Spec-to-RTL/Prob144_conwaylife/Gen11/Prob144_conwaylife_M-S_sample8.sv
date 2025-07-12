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
            integer index = i * 16 + j;
            reg [3:0] alive_neighbors = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;
                    int index_x = (i + x + 16) % 16;
                    int index_y = (j + y + 16) % 16;
                    int neighbor_index = index_x + index_y * 16;
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