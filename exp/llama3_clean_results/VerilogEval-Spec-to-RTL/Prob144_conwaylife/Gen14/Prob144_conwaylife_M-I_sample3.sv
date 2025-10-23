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
        reg [255:0] next_grid;
        for (int i = 0; i < 256; i++) begin
            reg [3:0] count;
            count = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    reg [7:0] j = (i / 16) + x;
                    reg [7:0] k = (i % 16) + y;
                    if (grid[((((j % 16) * 16) + (k % 16)))]) begin
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