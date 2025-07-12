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
        reg [255:0] grid_next;
        for (int i = 0; i < 16; i = i + 1) begin
            for (int j = 0; j < 16; j = j + 1) begin
                reg [2:0] neighbours;
                neighbours = 0;
                for (int x = -1; x <= 1; x = x + 1) begin
                    for (int y = -1; y <= 1; y = y + 1) begin
                        if ((x == 0) && (y == 0)) begin
                            continue;
                        end
                        int new_i, new_j;
                        new_i = (i + x + 16) % 16;
                        new_j = (j + y + 16) % 16;
                        int index = (new_i * 16) + new_j;
                        if (grid[index]) begin
                            neighbours = neighbours + 1;
                        end
                    end
                end
                int index = (i * 16) + j;
                if (neighbours <= 1 || neighbours >= 4) begin
                    grid_next[index] = 0;
                end else if (neighbours == 2) begin
                    grid_next[index] = grid[index];
                end else begin
                    grid_next[index] = 1;
                end
            end
        end
        grid <= grid_next;
    end
end

assign q = grid;

endmodule