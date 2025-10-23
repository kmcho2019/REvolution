module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

// Register to store the current state of the game
reg [255:0] current_state;

// Initialize the output
assign q = current_state;

// Load the initial state
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        // Calculate the next state based on the current state
        current_state <= calculate_next_state(current_state);
    end
end

// Function to calculate the next state
function [255:0] calculate_next_state;
    input [255:0] state;
    reg [255:0] next_state;
    integer i, j;

    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            integer index = i * 16 + j;
            integer alive_neighbors = count_alive_neighbors(state, i, j);

            if (alive_neighbors == 2) begin
                // Cell state does not change
                next_state[index] = state[index];
            end else if (alive_neighbors == 3) begin
                // Cell becomes alive
                next_state[index] = 1'b1;
            end else begin
                // Cell becomes dead
                next_state[index] = 1'b0;
            end
        end
    end

    calculate_next_state = next_state;
endfunction

// Function to count the number of alive neighbors
function integer count_alive_neighbors;
    input [255:0] state;
    input [3:0] i, j;
    reg [2:0] alive_neighbors;

    alive_neighbors = 0;

    // Check all 8 neighboring cells
    for (integer x = -1; x <= 1; x++) begin
        for (integer y = -1; y <= 1; y++) begin
            if ((x == 0) && (y == 0)) begin
                // Skip the cell itself
                continue;
            end

            integer neighbor_i = (i + x + 16) % 16;
            integer neighbor_j = (j + y + 16) % 16;
            integer neighbor_index = neighbor_i * 16 + neighbor_j;

            if (state[neighbor_index] == 1'b1) begin
                alive_neighbors = alive_neighbors + 1;
            end
        end
    end

    count_alive_neighbors = alive_neighbors;
endfunction

endmodule