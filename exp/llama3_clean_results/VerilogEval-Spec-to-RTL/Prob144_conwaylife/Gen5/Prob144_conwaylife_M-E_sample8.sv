module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;

// Combinational logic to count alive neighbours
always @(*) begin
    for (int i = 0; i < 256; i++) begin
        int col = i % 16;
        int row = i / 16;
        reg [2:0] neighbours = 0;
        
        // Count alive neighbours
        for (int x = -1; x <= 1; x++) begin
            for (int y = -1; y <= 1; y++) begin
                if ((x == 0) && (y == 0)) begin
                    continue;
                end
                int new_col = (col + x + 16) % 16;
                int new_row = (row + y + 16) % 16;
                int new_idx = (new_row * 16) + new_col;
                if (grid[new_idx]) begin
                    neighbours = neighbours + 1;
                end
            end
        end
        
        // Update next_grid state
        case (neighbours)
            0, 1: next_grid[i] = 0;
            2: next_grid[i] = grid[i];
            3: next_grid[i] = 1;
            default: next_grid[i] = 0;
        endcase
    end
end

// Sequential logic to update grid state
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        grid <= next_grid;
    end
    q <= grid;
end

endmodule