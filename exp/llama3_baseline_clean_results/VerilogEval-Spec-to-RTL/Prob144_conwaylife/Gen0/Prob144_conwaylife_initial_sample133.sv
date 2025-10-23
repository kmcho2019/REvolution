module TopModule(
    input               clk,
    input               load,
    input       [255:0] data,
    output reg  [255:0] q
);

// Function to count the number of neighbors for a cell
function [2:0] count_neighbors;
    input [255:0] state;
    input [7:0]  row;
    input [7:0]  col;
    reg    [2:0] count_neighbors;
    begin
        count_neighbors = 0;
        // Count neighbors in a 3x3 window around the cell, wrapping around the edges
        for (int i = -1; i <= 1; i++) begin
            for (int j = -1; j <= 1; j++) begin
                if ((i == 0) && (j == 0)) begin
                    // Don't count the cell itself
                end else begin
                    // Calculate the row and column of the neighbor, wrapping around the edges
                    int neighbor_row = (row + i) % 16;
                    int neighbor_col = (col + j) % 16;
                    // Calculate the index of the neighbor in the state vector
                    int neighbor_index = (neighbor_row * 16) + neighbor_col;
                    // Increment the count if the neighbor is alive
                    count_neighbors = count_neighbors + state[neighbor_index];
                end
            end
        end
        count_neighbors = count_neighbors;
    end
endfunction

// Function to determine the next state of a cell based on the neighbor count
function [0:0] next_state;
    input [2:0] neighbors;
    input [0:0] current_state;
    begin
        case (neighbors)
            0, 1: next_state = 0;
            2:   next_state = current_state;
            3:   next_state = 1;
            default: next_state = 0;
        endcase
    end
endfunction

// Register to store the current state of the game
reg [255:0] next_q;

// Combinational logic to update the next state
always @(*) begin
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            int index = (i * 16) + j;
            reg [2:0] neighbors;
            neighbors = count_neighbors(q, i, j);
            next_q[index] = next_state(neighbors, q[index]);
        end
    end
end

// Sequential logic to update the current state
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule