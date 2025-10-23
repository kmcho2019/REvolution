module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Define the size of the grid
localparam GRID_SIZE = 16;

// Function to calculate the number of alive neighbors for a cell
function [2:0] count_neighbors;
    input [255:0] grid;
    input [7:0] row;
    input [7:0] col;
    reg [2:0] count = 0;
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) begin
                continue;
            end
            int new_row = (row + i + GRID_SIZE) % GRID_SIZE;
            int new_col = (col + j + GRID_SIZE) % GRID_SIZE;
            int index = (new_row * GRID_SIZE) + new_col;
            if (grid[index]) begin
                count = count + 1;
            end
        end
    end
    count_neighbors = count;
endfunction

// Update the grid state
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        reg [255:0] new_q;
        for (int i = 0; i < GRID_SIZE; i++) begin
            for (int j = 0; j < GRID_SIZE; j++) begin
                int index = (i * GRID_SIZE) + j;
                reg [2:0] neighbors = count_neighbors(q, i, j);
                if (neighbors == 3) begin
                    new_q[index] = 1;
                end else if (neighbors == 2 && q[index]) begin
                    new_q[index] = 1;
                end else begin
                    new_q[index] = 0;
                end
            end
        end
        q <= new_q;
    end
end

endmodule