module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

// Initialize q_reg with the data when load is high
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Update q_reg based on the game logic
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                // Calculate the index of the current cell
                int index = i * 16 + j;
                
                // Count the number of alive neighbors
                reg [2:0] alive_neighbors;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue; // Skip the current cell
                        
                        // Calculate the indices of the neighbors, handling edge cases
                        int neighbor_i = (i + x + 16) % 16;
                        int neighbor_j = (j + y + 16) % 16;
                        int neighbor_index = neighbor_i * 16 + neighbor_j;
                        
                        // Count the alive neighbors
                        alive_neighbors += q_reg[neighbor_index];
                    end
                end
                
                // Apply the game rules
                if (alive_neighbors < 2 || alive_neighbors > 3) begin
                    q_reg[index] <= 1'b0; // Cell becomes 0
                end else if (alive_neighbors == 3) begin
                    q_reg[index] <= 1'b1; // Cell becomes 1
                end else begin
                    // Cell state does not change
                    // q_reg[index] remains the same
                end
            end
        end
    end
end

// Assign the output q to the internal register q_reg
assign q = q_reg;

endmodule