module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;

// Initialize current_state
initial begin
    current_state = 256'd0;
end

// Update current_state on clock edge
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= update_state(current_state);
    end
end

// Update q on every clock cycle
assign q = current_state;

// Function to update the state of the grid
function [255:0] update_state;
    input [255:0] state;
    reg [255:0] next_state;
    reg [2:0] neighbors;

    integer i, j;
    begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Calculate the index of the current cell
                integer index = i * 16 + j;

                // Count the number of alive neighbors
                neighbors = count_neighbors(state, i, j);

                // Apply the game rules
                if (neighbors == 2) begin
                    next_state[index] = state[index];
                end else if (neighbors == 3) begin
                    next_state[index] = 1'd1;
                end else begin
                    next_state[index] = 1'd0;
                end
            end
        end

        update_state = next_state;
    end
endfunction

// Function to count the number of alive neighbors for a cell
function [2:0] count_neighbors;
    input [255:0] state;
    input [3:0] i, j;
    reg [2:0] count;

    integer x, y;
    begin
        count = 3'd0;
        for (x = -1; x <= 1; x = x + 1) begin
            for (y = -1; y <= 1; y = y + 1) begin
                if (x == 0 && y == 0) begin
                    continue;
                end

                // Calculate the index of the neighboring cell, handling wrap-around cases
                integer neighbor_i = (i + x + 16) % 16;
                integer neighbor_j = (j + y + 16) % 16;
                integer neighbor_index = neighbor_i * 16 + neighbor_j;

                // Check if the neighboring cell is alive
                if (state[neighbor_index]) begin
                    count = count + 1'd1;
                end
            end
        end

        count_neighbors = count;
    end
endfunction

endmodule