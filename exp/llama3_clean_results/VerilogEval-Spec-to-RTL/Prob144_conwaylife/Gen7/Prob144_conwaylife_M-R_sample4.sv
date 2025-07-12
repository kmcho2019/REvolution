module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] grid_next;

// Combinational logic to calculate the next state of the grid
always @(*) begin
    grid_next = 256'b0;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            reg [2:0] neighbours;
            neighbours = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    int new_i = (i + x + 16) % 16;
                    int new_j = (j + y + 16) % 16;
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
end

// Sequential logic to update the current state of the grid
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        grid <= grid_next;
    end
end

assign q = grid;

endmodule