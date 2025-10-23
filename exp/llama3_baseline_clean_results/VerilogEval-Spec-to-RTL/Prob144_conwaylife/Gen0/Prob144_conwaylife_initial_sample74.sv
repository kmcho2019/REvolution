module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_state;

    always @(*) begin
        // Initialize next_state with the current state
        next_state = q;

        // Iterate over each cell in the grid
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                // Calculate the index of the current cell
                int index = i * 16 + j;

                // Count the number of alive neighbors
                int alive_neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        // Skip the current cell
                        if (x == 0 && y == 0) continue;

                        // Calculate the neighbor's position on the toroid
                        int neighbor_x = (i + x + 16) % 16;
                        int neighbor_y = (j + y + 16) % 16;

                        // Calculate the neighbor's index
                        int neighbor_index = neighbor_x * 16 + neighbor_y;

                        // Check if the neighbor is alive
                        if (q[neighbor_index] == 1'b1) begin
                            alive_neighbors++;
                        end
                    end
                end

                // Update the cell's state based on the number of alive neighbors
                if (q[index] == 1'b0 && alive_neighbors == 3) begin
                    next_state[index] = 1'b1;
                end else if (q[index] == 1'b1 && (alive_neighbors < 2 || alive_neighbors > 3)) begin
                    next_state[index] = 1'b0;
                end
            end
        end
    end

    always @(posedge clk) begin
        // Load the initial state if load is high
        if (load) begin
            q <= data;
        end else begin
            // Update the current state with the next state
            q <= next_state;
        end
    end

endmodule