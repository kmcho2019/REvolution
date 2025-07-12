module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

// Initialize the grid with the loaded data
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Update the grid state according to the game rules
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] alive_neighbours;
                // Calculate the number of alive neighbours for each cell
                alive_neighbours = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue; // Do not count the cell itself
                        reg [7:0] row;
                        reg [7:0] col;
                        row = (i + x) % 16;
                        col = (j + y) % 16;
                        if (q_reg[(row * 16) + col] == 1'b1) begin
                            alive_neighbours = alive_neighbours + 1;
                        end
                    end
                end
                // Apply the game rules to update the cell state
                if (alive_neighbours <= 1 || alive_neighbours >= 4) begin
                    q_reg[(i * 16) + j] <= 1'b0;
                end else if (alive_neighbours == 3) begin
                    q_reg[(i * 16) + j] <= 1'b1;
                end
            end
        end
    end
end

// Assign the output to the updated grid state
assign q = q_reg;

endmodule