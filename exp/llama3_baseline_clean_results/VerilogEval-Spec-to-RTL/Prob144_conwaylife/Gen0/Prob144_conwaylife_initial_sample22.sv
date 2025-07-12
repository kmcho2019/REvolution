module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;
reg [2:0] neighbors [15:0][15:0];

integer i, j;

always @(*) begin
    // Initialize neighbors array
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            neighbors[i][j] = 0;
        end
    end

    // Calculate number of neighbors for each cell
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            // Calculate index of current cell
            integer cell_index = i * 16 + j;

            // Check all 8 neighboring cells
            for (integer x = -1; x <= 1; x++) begin
                for (integer y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue; // Skip current cell

                    // Calculate index of neighboring cell, wrapping around edges
                    integer neighbor_i = (i + x + 16) % 16;
                    integer neighbor_j = (j + y + 16) % 16;
                    integer neighbor_index = neighbor_i * 16 + neighbor_j;

                    // If neighboring cell is alive, increment neighbors count
                    if (current_state[neighbor_index] == 1'b1) begin
                        neighbors[i][j] = neighbors[i][j] + 1'b1;
                    end
                end
            end
        end
    end

    // Update state of each cell based on number of neighbors
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            // Calculate index of current cell
            integer cell_index = i * 16 + j;

            // Apply game rules
            if (neighbors[i][j] <= 1) begin
                next_state[cell_index] = 1'b0;
            end else if (neighbors[i][j] == 2) begin
                next_state[cell_index] = current_state[cell_index];
            end else if (neighbors[i][j] == 3) begin
                next_state[cell_index] = 1'b1;
            end else begin
                next_state[cell_index] = 1'b0;
            end
        end
    end
end

always @(posedge clk) begin
    if (load == 1'b1) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule