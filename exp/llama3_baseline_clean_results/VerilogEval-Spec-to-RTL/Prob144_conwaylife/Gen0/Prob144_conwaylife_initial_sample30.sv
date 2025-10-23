module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q; // Next state of the game

// Function to calculate the number of alive neighbors for a cell
function [3:0] count_neighbors;
    input [255:0] state;
    input [7:0] row;
    input [7:0] col;
    reg [3:0] count;

    begin
        count = 0;
        // Toroidal boundary conditions
        for (int i = -1; i <= 1; i++) begin
            for (int j = -1; j <= 1; j++) begin
                if (i == 0 && j == 0) continue; // Skip the cell itself
                count += state[((((row + i + 16) % 16) * 16) + ((col + j + 16) % 16))];
            end
        end
        count_neighbors = count;
    end
endfunction

always @(*) begin
    // Load the initial state when load is high
    if (load) begin
        next_q = data;
    end else begin
        // Update the state of the game
        for (int row = 0; row < 16; row++) begin
            for (int col = 0; col < 16; col++) begin
                reg [3:0] neighbors;
                neighbors = count_neighbors(q, row, col);
                case (neighbors)
                    0, 1: next_q[(row * 16) + col] = 0; // Cell becomes 0
                    2: next_q[(row * 16) + col] = q[(row * 16) + col]; // Cell state does not change
                    3: next_q[(row * 16) + col] = 1; // Cell becomes 1
                    default: next_q[(row * 16) + col] = 0; // Cell becomes 0
                endcase
            end
        end
    end
end

always @(posedge clk) begin
    q <= next_q; // Update the current state
end

endmodule