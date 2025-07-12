module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Initialize grid
integer i, j;
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        // Update grid
        for (i = 0; i < 256; i = i + 1) begin
            // Calculate row and column
            integer row, col;
            row = i / 16;
            col = i % 16;

            // Count alive neighbors
            reg [2:0] alive_neighbors;
            alive_neighbors = count_neighbors(q, row, col);

            // Update cell state
            if (alive_neighbors == 0 || alive_neighbors == 1) begin
                q[i] <= 0;
            end else if (alive_neighbors == 2) begin
                // Do nothing, keep current state
            end else if (alive_neighbors == 3) begin
                q[i] <= 1;
            end else begin
                q[i] <= 0;
            end
        end
    end
end

// Function to count alive neighbors
function reg [2:0] count_neighbors;
input [255:0] grid;
input [3:0] row;
input [3:0] col;
reg [2:0] count;
integer i, j;

count_neighbors = 0;
for (i = -1; i <= 1; i = i + 1) begin
    for (j = -1; j <= 1; j = j + 1) begin
        if (i == 0 && j == 0) begin
            // Skip current cell
        end else begin
            integer new_row, new_col;
            new_row = (row + i + 16) % 16;
            new_col = (col + j + 16) % 16;
            integer index;
            index = new_row * 16 + new_col;
            if (grid[index]) begin
                count_neighbors = count_neighbors + 1;
            end
        end
    end
end
endfunction

endmodule