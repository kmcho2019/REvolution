module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [15:0] grid[15:0];
reg [15:0] new_grid[15:0];

// Function to count alive neighbours
function integer count_alive_neighbours;
    input [3:0] row;
    input [3:0] col;
    integer count;
    begin
        count = 0;
        for (int i = -1; i <= 1; i++) begin
            for (int j = -1; j <= 1; j++) begin
                if ((i == 0) && (j == 0)) begin
                    continue;
                end
                // Calculate row and column, handling wrap-around
                int new_row = (row + i + 16) % 16;
                int new_col = (col + j + 16) % 16;
                // Count the neighbour
                if (grid[new_row][new_col]) begin
                    count = count + 1;
                end
            end
        end
        count_alive_neighbours = count;
    end
endfunction

// Load initial state
always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = (i * 16) + j;
                grid[i][j] = data[index];
            end
        end
    end
end

// Update grid state
always @(posedge clk) begin
    if (!load) begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = (i * 16) + j;
                integer neighbours = count_alive_neighbours(i, j);
                case (neighbours)
                    0, 1: new_grid[i][j] = 0;
                    2: new_grid[i][j] = grid[i][j];
                    3: new_grid[i][j] = 1;
                    default: new_grid[i][j] = 0;
                endcase
            end
        end
        // Assign new grid to output and update grid
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int index = (i * 16) + j;
                q[index] = new_grid[i][j];
                grid[i][j] = new_grid[i][j];
            end
        end
    end
end

endmodule