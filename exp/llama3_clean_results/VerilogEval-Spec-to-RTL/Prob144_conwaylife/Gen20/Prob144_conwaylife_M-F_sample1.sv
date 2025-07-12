module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (reg i = 0; i < 256; i++) begin
            reg [2:0] count;
            count = 0;
            for (reg x = -1; x <= 1; x++) begin
                for (reg y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;
                    reg nx, ny, idx;
                    nx = (i / 16 + x + 16) % 16;
                    ny = (i % 16 + y + 16) % 16;
                    idx = nx * 16 + ny;
                    count += grid[idx];
                end
            end
            if (count <= 1 || count >= 4) next_grid[i] = 1'b0;
            else if (count == 3) next_grid[i] = 1'b1;
            else next_grid[i] = grid[i];
        end
        grid <= next_grid;
    end
end

assign q = grid;

endmodule