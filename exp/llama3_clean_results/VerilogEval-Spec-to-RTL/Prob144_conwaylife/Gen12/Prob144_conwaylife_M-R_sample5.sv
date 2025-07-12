module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

integer i, x, y;
integer j, k;
integer count;

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (i = 0; i < 256; i++) begin
            count = 0;
            for (x = -1; x <= 1; x++) begin
                for (y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    j = (i / 16) + x;
                    k = (i % 16) + y;
                    if (grid[((j % 16) * 16) + (k % 16)]) begin
                        count = count + 1;
                    end
                end
            end
            if (count <= 1 || count >= 4) begin
                next_grid[i] = 1'b0;
            end else if (count == 3) begin
                next_grid[i] = 1'b1;
            end else begin
                next_grid[i] = grid[i];
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule