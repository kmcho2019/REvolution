module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;

// Load the input data into the current state
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        // Update the current state based on the game logic
        current_state <= update_state(current_state);
    end
end

// Update the output q
assign q = current_state;

// Function to update the state of the grid
function [255:0] update_state;
input [255:0] current_state;
reg [255:0] next_state;
integer i, j, x, y, neighbors;

for (i = 0; i < 256; i = i + 1) begin
    // Convert the bit index to row and column
    j = i % 16;
    x = i / 16;
    neighbors = 0;

    // Count the neighbors
    for (y = -1; y <= 1; y = y + 1) begin
        for (j = -1; j <= 1; j = j + 1) begin
            if (y == 0 && j == 0) begin
                continue;
            end

            // Calculate the neighbor's row and column, considering wrapping around
            integer neighbor_row = (x + y + 16) % 16;
            integer neighbor_col = (j + i % 16 + 16) % 16;

            // Calculate the neighbor's bit index
            integer neighbor_index = neighbor_row * 16 + neighbor_col;

            // Check if the neighbor is alive
            if (current_state[neighbor_index]) begin
                neighbors = neighbors + 1;
            end
        end
    end

    // Update the cell's state based on the game rules
    if (neighbors <= 1 || neighbors >= 4) begin
        next_state[i] = 0;
    end else if (neighbors == 3) begin
        next_state[i] = 1;
    end else begin
        next_state[i] = current_state[i];
    end
end

update_state = next_state;
endfunction

endmodule