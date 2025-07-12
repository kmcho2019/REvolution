module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [15:0][15:0] grid;
reg [15:0][15:0] next_grid;

always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                grid[i][j] <= data[(i * 16) + j];
            end
        end
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [3:0] count;
                count = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if ((x == 0) && (y == 0)) begin
                            continue;
                        end
                        reg [4:0] k = (i + x) % 16;
                        reg [4:0] l = (j + y) % 16;
                        if (grid[k][l]) begin
                            count = count + 1;
                        end
                    end
                end
                if (count <= 1 || count >= 4) begin
                    next_grid[i][j] = 1'b0;
                end else if (count == 3) begin
                    next_grid[i][j] = 1'b1;
                end else begin
                    next_grid[i][j] = grid[i][j];
                end
            end
        end
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                grid[i][j] <= next_grid[i][j];
            end
        end
    end
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            q[(i * 16) + j] <= grid[i][j];
        end
    end
end

endmodule