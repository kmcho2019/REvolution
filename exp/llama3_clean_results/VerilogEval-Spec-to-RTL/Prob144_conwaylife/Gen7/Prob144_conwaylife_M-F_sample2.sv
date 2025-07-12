module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid; // Temporary variable for next state

integer row, col, index, new_row, new_col, count;

always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        // Initialize next_grid with the current state of grid
        next_grid <= grid;
        
        // Iterate over each cell in the grid
        for (row = 0; row < 16; row++) begin
            for (col = 0; col < 16; col++) begin
                index = row * 16 + col;
                count = 0;
                
                // Count neighbors
                for (integer i = -1; i <= 1; i++) begin
                    for (integer j = -1; j <= 1; j++) begin
                        if ((i == 0) && (j == 0)) begin
                            continue;
                        end
                        new_row = (row + i + 16) % 16;
                        new_col = (col + j + 16) % 16;
                        if (grid[new_row * 16 + new_col]) begin
                            count = count + 1;
                        end
                    end
                end
                
                // Update next state based on neighbor count
                case (count)
                    0, 1: next_grid[index] <= 1'b0;
                    2: next_grid[index] <= grid[index];
                    3: next_grid[index] <= 1'b1;
                    default: next_grid[index] <= 1'b0;
                endcase
            end
        end
    end
    // Update grid and output
    grid <= next_grid;
    q <= grid;
end

endmodule