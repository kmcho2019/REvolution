module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

// Function to count neighbors for a given cell
function [2:0] count_neighbors;
    input [255:0] state;
    input [7:0] row, col;
    reg [2:0] neighbors;
    reg [255:0] mask;

    // Create a mask to select the cell's neighbors
    mask = 0;
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) continue; // Skip the cell itself
            mask[(row + i + 16) % 16 * 16 + (col + j + 16) % 16] = 1;
        end
    end

    // Count the number of neighbors
    neighbors = 0;
    for (int i = 0; i < 256; i++) begin
        if (mask[i] && state[i]) neighbors++;
    end

    count_neighbors = neighbors;
endfunction

// Update the game state
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        // Update the game state
        for (int i = 0; i < 256; i++) begin
            reg [7:0] row, col;
            reg [2:0] neighbors;

            row = i / 16;
            col = i % 16;

            neighbors = count_neighbors(q, row, col);

            case (neighbors)
                0, 1: next_q[i] = 0;
                2: next_q[i] = q[i];
                3: next_q[i] = 1;
                default: next_q[i] = 0;
            endcase
        end

        q <= next_q;
    end
end

endmodule