module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [15:0] grid[15:0];
reg [15:0] new_grid[15:0];

// Combinational logic to count alive neighbours
reg [2:0] neighbours[15:0][15:0];

always @(*) begin
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            neighbours[i][j] = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    int new_i = (i + x + 16) % 16;
                    int new_j = (j + y + 16) % 16;
                    if (grid[new_i][new_j]) begin
                        neighbours[i][j] = neighbours[i][j] + 1;
                    end
                end
            end
        end
    end
end

// Load initial state or update grid state
always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = (i * 16) + j;
                grid[i][j] <= data[index];
            end
        end
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                case (neighbours[i][j])
                    0, 1: new_grid[i][j] = 0;
                    2: new_grid[i][j] = grid[i][j];
                    3: new_grid[i][j] = 1;
                    default: new_grid[i][j] = 0;
                endcase
            end
        end
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = (i * 16) + j;
                q[index] <= new_grid[i][j];
                grid[i][j] <= new_grid[i][j];
            end
        end
    end
end

endmodule