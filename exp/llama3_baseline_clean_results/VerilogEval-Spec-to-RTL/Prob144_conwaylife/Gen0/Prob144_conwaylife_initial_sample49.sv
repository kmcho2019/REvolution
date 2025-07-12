module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Function to calculate the number of neighbors for a given cell
function [2:0] count_neighbors;
    input [255:0] q;
    input [7:0] row, col;
    reg [2:0] count_neighbors;

    count_neighbors = 0;

    // Check all 8 neighboring cells
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) continue; // Skip the current cell

            int r = (row + i + 16) % 16; // Toroid, so wrap around
            int c = (col + j + 16) % 16;

            if (q[r * 16 + c]) count_neighbors = count_neighbors + 1;
        end
    end
endfunction

// Always block to update the state of the grid
always @(posedge clk) begin
    if (load) begin
        // Load the initial state into the grid
        q <= data;
    end else begin
        // Update the grid based on the current state
        reg [255:0] next_q;
        for (int i = 0; i < 256; i++) begin
            int row = i / 16;
            int col = i % 16;
            reg [2:0] neighbors = count_neighbors(q, row, col);

            if (neighbors <= 1 || neighbors >= 4) begin
                next_q[i] = 0;
            end else if (neighbors == 2) begin
                next_q[i] = q[i];
            end else if (neighbors == 3) begin
                next_q[i] = 1;
            end
        end
        q <= next_q;
    end
end

endmodule