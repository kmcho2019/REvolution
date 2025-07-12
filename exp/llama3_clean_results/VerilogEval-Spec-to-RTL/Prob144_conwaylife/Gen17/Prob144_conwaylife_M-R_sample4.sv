module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [15:0] grid [15:0];
reg [255:0] next_grid;

// Load initial state
always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                grid[i][j] = data[i * 16 + j];
            end
        end
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [3:0] count;
                count = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) begin
                            continue;
                        end
                        reg [4:0] ni;
                        reg [4:0] nj;
                        ni = (i + x + 16) % 16;
                        nj = (j + y + 16) % 16;
                        count = count + grid[ni][nj];
                    end
                end
                if (count <= 1 || count >= 4) begin
                    next_grid[i * 16 + j] = 1'b0;
                end else if (count == 3) begin
                    next_grid[i * 16 + j] = 1'b1;
                end else begin
                    next_grid[i * 16 + j] = grid[i][j];
                end
            end
        end
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                grid[i][j] = next_grid[i * 16 + j];
            end
        end
    end
end

assign q = next_grid;

endmodule