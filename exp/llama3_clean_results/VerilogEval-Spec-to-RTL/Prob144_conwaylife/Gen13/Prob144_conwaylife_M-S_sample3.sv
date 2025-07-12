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
        for (int i = 0; i < 256; i++) begin
            reg [2:0] count;
            count = 3'b0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    int j, k;
                    j = (i / 16) + x;
                    k = (i % 16) + y;
                    if (grid[((j % 16) * 16) + (k % 16)]) begin
                        count = count + 1'b1;
                    end
                end
            end
            if (count <= 1 || count >= 4) begin
                grid[i] <= 1'b0;
            end else if (count == 3) begin
                grid[i] <= 1'b1;
            end else begin
                grid[i] <= grid[i];
            end
        end
    end
    q <= grid;
end

endmodule