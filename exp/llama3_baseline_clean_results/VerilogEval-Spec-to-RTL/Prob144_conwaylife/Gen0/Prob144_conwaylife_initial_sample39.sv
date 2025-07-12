module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

always @(*) begin
    next_q = q; // Initialize next_q with current q

    for (int i = 0; i < 16; i++) begin // Iterate over each row
        for (int j = 0; j < 16; j++) begin // Iterate over each column
            reg [2:0] alive_neighbors; // Count of alive neighbors

            // Calculate the index of the current cell in the 256-bit vector
            int cell_index = i * 16 + j;

            // Extract the state of the current cell
            reg current_cell = q[cell_index];

            // Initialize the count of alive neighbors
            alive_neighbors = 3'b000;

            // Calculate the indices of the neighbors in the 256-bit vector
            // and count the alive neighbors
            for (int x = -1; x <= 1; x++) begin // Iterate over neighboring rows
                for (int y = -1; y <= 1; y++) begin // Iterate over neighboring columns
                    if (x == 0 && y == 0) continue; // Skip the current cell

                    int neighbor_row = (i + x + 16) % 16; // Wrap around rows
                    int neighbor_col = (j + y + 16) % 16; // Wrap around columns

                    int neighbor_index = neighbor_row * 16 + neighbor_col;

                    // Check if the neighbor is alive and increment the count
                    if (q[neighbor_index]) begin
                        alive_neighbors = alive_neighbors + 1'b1;
                    end
                end
            end

            // Apply the game rules to determine the new state of the current cell
            case (alive_neighbors)
                3'b000, 3'b001: next_q[cell_index] = 1'b0; // 0-1 alive neighbors: cell dies
                3'b010: next_q[cell_index] = current_cell; // 2 alive neighbors: cell stays the same
                3'b011: next_q[cell_index] = 1'b1; // 3 alive neighbors: cell becomes alive
                default: next_q[cell_index] = 1'b0; // 4+ alive neighbors: cell dies
            endcase
        end
    end
end

endmodule