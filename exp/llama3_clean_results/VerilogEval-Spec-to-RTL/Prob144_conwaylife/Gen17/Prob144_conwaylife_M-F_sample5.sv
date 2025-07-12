module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

// Load initial state
always @(posedge clk) begin
    if (load) begin
        grid = data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [3:0] count;
                count = 0;
                // Count neighbors
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) begin
                            // Don't count the current cell
                            continue;
                        end
                        reg [4:0] row;
                        reg [4:0] col;
                        row = (i + x + 16) % 16;
                        col = (j + y + 16) % 16;
                        count = count + grid[row * 16 + col];
                    end
                end
                // Update cell state
                if (count <= 1 || count >= 4) begin
                    next_grid[i * 16 + j] = 1'b0;
                end else if (count == 3) begin
                    next_grid[i * 16 + j] = 1'b1;
                end else begin
                    next_grid[i * 16 + j] = grid[i * 16 + j];
                end
            end
        end
        grid = next_grid;
    end
end

// Output final state
always @(posedge clk) begin
    q = grid;
end

endmodule