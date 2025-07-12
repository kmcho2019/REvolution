module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

always @(*) begin
    for (int i = 0; i < 256; i++) begin
        int count = 0;
        for (int x = -1; x <= 1; x++) begin
            for (int y = -1; y <= 1; y++) begin
                if (x == 0 && y == 0) continue;
                int nx = (i / 16 + x + 16) % 16;
                int ny = (i % 16 + y + 16) % 16;
                int idx = nx * 16 + ny;
                count += grid[idx];
            end
        end
        if (count <= 1 || count >= 4) next_grid[i] = 1'b0;
        else if (count == 3) next_grid[i] = 1'b1;
        else next_grid[i] = grid[i];
    end
end

always @(posedge clk) begin
    if (load) grid <= data;
    else grid <= next_grid;
end

assign q = grid;

endmodule