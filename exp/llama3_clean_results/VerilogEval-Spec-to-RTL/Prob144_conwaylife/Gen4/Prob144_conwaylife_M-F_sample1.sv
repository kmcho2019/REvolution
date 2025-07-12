module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

// Combinational logic to count alive neighbours
reg [2:0] neighbours[255:0];

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        // Initialize neighbours to 0
        for (int i = 0; i < 256; i++) begin
            neighbours[i] = 0;
        end
        
        // Count alive neighbours
        for (int i = 0; i < 256; i++) begin
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        continue;
                    end
                    int col = i % 16;
                    int row = i / 16;
                    int new_col = (col + x + 16) % 16;
                    int new_row = (row + y + 16) % 16;
                    int new_idx = (new_row * 16) + new_col;
                    if (grid[new_idx]) begin
                        neighbours[i] = neighbours[i] + 1;
                    end
                end
            end
        end
        
        // Update grid state
        for (int i = 0; i < 256; i++) begin
            case (neighbours[i])
                0, 1: grid[i] <= 0;
                2: grid[i] <= grid[i];
                3: grid[i] <= 1;
                default: grid[i] <= 0;
            endcase
        end
    end
    q <= grid;
end

endmodule