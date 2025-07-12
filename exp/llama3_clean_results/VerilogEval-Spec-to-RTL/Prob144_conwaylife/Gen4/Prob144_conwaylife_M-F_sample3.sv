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
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] neighbours_count;
                neighbours_count = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if ((x == 0) && (y == 0)) begin
                            continue;
                        end
                        int new_i = (i + x + 16) % 16;
                        int new_j = (j + y + 16) % 16;
                        int index = (new_i * 16) + new_j;
                        if (grid[index]) begin
                            neighbours_count = neighbours_count + 1;
                        end
                    end
                end
                int index = (i * 16) + j;
                if (neighbours_count == 0 || neighbours_count == 1) begin
                    grid_next[index] = 0;
                end else if (neighbours_count == 2) begin
                    grid_next[index] = grid[index];
                end else if (neighbours_count == 3) begin
                    grid_next[index] = 1;
                end else begin
                    grid_next[index] = 0;
                end
            end
        end
        grid <= grid_next;
    end
    q <= grid;
end

endmodule