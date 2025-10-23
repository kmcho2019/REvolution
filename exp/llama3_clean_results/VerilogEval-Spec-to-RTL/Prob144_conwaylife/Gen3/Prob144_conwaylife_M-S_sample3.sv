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
        reg [255:0] new_grid;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = (i * 16) + j;
                reg [2:0] neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if ((x == 0) && (y == 0)) begin
                            // Skip the current cell
                        end else begin
                            int new_i = (i + x + 16) % 16;
                            int new_j = (j + y + 16) % 16;
                            int new_index = (new_i * 16) + new_j;
                            if (grid[new_index]) begin
                                neighbors = neighbors + 1;
                            end
                        end
                    end
                end
                case (neighbors)
                    0, 1: new_grid[index] = 0;
                    2: new_grid[index] = grid[index];
                    3: new_grid[index] = 1;
                    default: new_grid[index] = 0;
                endcase
            end
        end
        grid <= new_grid;
    end
    q <= grid;
end

endmodule