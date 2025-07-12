module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_state;

always @(*) begin
    // Initialize next_state to the current state of q
    next_state = q;

    // Iterate over each cell in the grid
    for (int i = 0; i < 256; i++) begin
        // Calculate the row and column of the current cell
        int row = i / 16;
        int col = i % 16;

        // Initialize the count of neighbors to 0
        int neighbors = 0;

        // Iterate over each possible neighbor of the current cell
        for (int x = -1; x <= 1; x++) begin
            for (int y = -1; y <= 1; y++) begin
                // Skip the current cell itself
                if (x == 0 && y == 0) continue;

                // Calculate the row and column of the neighbor
                int n_row = (row + x + 16) % 16;
                int n_col = (col + y + 16) % 16;

                // Calculate the index of the neighbor in the vector
                int n_idx = n_row * 16 + n_col;

                // If the neighbor is alive, increment the count
                if (q[n_idx]) neighbors++;
            end
        end

        // Update the state of the current cell based on the number of neighbors
        if (neighbors <= 1 || neighbors >= 4) next_state[i] = 0;
        else if (neighbors == 3) next_state[i] = 1;
    end
end

always @(posedge clk) begin
    if (load) q <= data;
    else q <= next_state;
end

endmodule