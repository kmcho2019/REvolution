module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Function to count the number of alive neighbors for a given cell
function [3:0] count_neighbors;
    input [255:0] state;
    input [7:0] row;
    input [7:0] col;
    reg [3:0] count;
    begin
        count = 0;
        for (int i = -1; i <= 1; i = i + 1) begin
            for (int j = -1; j <= 1; j = j + 1) begin
                if ((i == 0) && (j == 0)) begin
                    // Don't count the cell itself
                    continue;
                end
                // Calculate the row and column of the neighboring cell, taking into account the toroidal nature of the grid
                int neighbor_row = (row + i + 16) % 16;
                int neighbor_col = (col + j + 16) % 16;
                // Check if the neighboring cell is alive
                if (state[(neighbor_row * 16 + neighbor_col)]) begin
                    count = count + 1;
                end
            end
        end
        count_neighbors = count;
    end
endfunction

// Function to update the state of a cell based on the number of alive neighbors
function [0:0] update_cell;
    input [3:0] neighbors;
    input [0:0] current_state;
    begin
        case (neighbors)
            0, 1: update_cell = 0;
            2: update_cell = current_state;
            3: update_cell = 1;
            default: update_cell = 0;
        endcase
    end
endfunction

// Update the state of the entire grid
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 256; i = i + 1) begin
            int row = i / 16;
            int col = i % 16;
            q[i] <= update_cell(count_neighbors(q, row, col), q[i]);
        end
    end
end

endmodule