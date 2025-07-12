module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

always @(posedge clk) begin
    if (load) begin
        grid = data;
    end else begin
        reg [255:0] next_grid;
        for (int i = 0; i < 256; i++) begin
            reg [3:0] count;
            count = 
                (grid[((i / 16) + 15) % 16 * 16 + ((i % 16) + 1) % 16]) +
                (grid[((i / 16) + 15) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
                (grid[((i / 16) + 1) % 16 * 16 + ((i % 16) + 1) % 16]) +
                (grid[((i / 16) + 1) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
                (grid[((i / 16) + 1) % 16 * 16 + (i % 16)]) +
                (grid[((i / 16) - 1 + 16) % 16 * 16 + ((i % 16) + 1) % 16]) +
                (grid[((i / 16) - 1 + 16) % 16 * 16 + ((i % 16) - 1 + 16) % 16]) +
                (grid[((i / 16) - 1 + 16) % 16 * 16 + (i % 16)]);
            if (count <= 1 || count >= 4) begin
                next_grid[i] = 1'b0;
            end else if (count == 3) begin
                next_grid[i] = 1'b1;
            end else begin
                next_grid[i] = grid[i];
            end
        end
        grid = next_grid;
    end
    q = grid;
end

endmodule