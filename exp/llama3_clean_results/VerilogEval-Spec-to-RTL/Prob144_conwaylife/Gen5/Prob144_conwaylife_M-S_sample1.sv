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
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = i * 16 + j;
                reg [3:0] alive_neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        int neighbor_index = ((i + x + 16) % 16) * 16 + (j + y + 16) % 16;
                        alive_neighbors += grid[neighbor_index];
                    end
                end
                case (alive_neighbors)
                    0, 1: q[index] <= 0;
                    2: q[index] <= grid[index];
                    3: q[index] <= 1;
                    default: q[index] <= 0;
                endcase
                grid[index] <= q[index];
            end
        end
    end
end

endmodule