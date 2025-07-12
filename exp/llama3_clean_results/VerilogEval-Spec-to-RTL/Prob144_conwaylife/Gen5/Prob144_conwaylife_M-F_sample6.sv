module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] new_grid;

// Update grid
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = i * 16 + j;
                int alive_neighbours = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        int ni = (i + x + 16) % 16;
                        int nj = (j + y + 16) % 16;
                        int neighbor_index = ni * 16 + nj;
                        alive_neighbours += grid[neighbor_index];
                    end
                end
                case (alive_neighbours)
                    0, 1: new_grid[index] <= 0;
                    2: new_grid[index] <= grid[index];
                    3: new_grid[index] <= 1;
                    default: new_grid[index] <= 0;
                endcase
            end
        end
        grid <= new_grid;
    end
    q <= grid;
end

endmodule