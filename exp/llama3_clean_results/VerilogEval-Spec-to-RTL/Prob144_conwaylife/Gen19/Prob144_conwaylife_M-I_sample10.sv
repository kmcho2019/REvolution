module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

integer count;

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (integer i = 0; i < 256; i++) begin
            count = 0;
            for (integer x = -1; x <= 1; x++) begin
                for (integer y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;
                    integer nx = (i / 16 + x + 16) % 16;
                    integer ny = (i % 16 + y + 16) % 16;
                    integer idx = nx * 16 + ny;
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