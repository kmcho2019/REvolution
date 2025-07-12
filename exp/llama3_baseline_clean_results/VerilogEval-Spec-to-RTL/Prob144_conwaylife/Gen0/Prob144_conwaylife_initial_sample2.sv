module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Calculate the number of alive neighbors for each cell
    wire [255:0] neighbors;

    genvar i;
    generate
        for (i = 0; i < 256; i++) begin
            wire [7:0] alive_neighbors;
            always @(q) begin
                alive_neighbors = 0;
                // Calculate the row and column of the current cell
                integer row = i / 16;
                integer col = i % 16;

                // Check all 8 neighboring cells
                for (integer j = -1; j <= 1; j++) begin
                    for (integer k = -1; k <= 1; k++) begin
                        if (j == 0 && k == 0) continue; // Skip the current cell

                        // Calculate the row and column of the neighboring cell
                        integer neighbor_row = (row + j) % 16;
                        if (neighbor_row < 0) neighbor_row += 16;
                        integer neighbor_col = (col + k) % 16;
                        if (neighbor_col < 0) neighbor_col += 16;

                        // Calculate the index of the neighboring cell
                        integer neighbor_index = neighbor_row * 16 + neighbor_col;

                        // Check if the neighboring cell is alive
                        if (q[neighbor_index]) alive_neighbors = alive_neighbors + 1;
                    end
                end
            end

            // Assign the number of alive neighbors to the neighbors wire
            assign neighbors[i] = alive_neighbors;
        end
    endgenerate

    // Calculate the next state of each cell based on the number of alive neighbors
    wire [255:0] next_state;

    genvar j;
    generate
        for (j = 0; j < 256; j++) begin
            always @(q, neighbors) begin
                if (neighbors[j] <= 1 || neighbors[j] >= 4) next_state[j] = 0;
                else if (neighbors[j] == 2) next_state[j] = q[j];
                else if (neighbors[j] == 3) next_state[j] = 1;
            end
        end
    endgenerate

    // Update the grid state at each clock cycle
    always @(posedge clk) begin
        if (load) q <= data;
        else q <= next_state;
    end

endmodule