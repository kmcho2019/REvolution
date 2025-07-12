module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

// Define the size of the grid
parameter GRID_SIZE = 16;

// Combinational logic to calculate the next state
always @(*) begin
    for (int i = 0; i < GRID_SIZE; i = i + 1) begin
        for (int j = 0; j < GRID_SIZE; j = j + 1) begin
            int index = (i * GRID_SIZE) + j;
            int alive_neighbors = 0;

            // Calculate the number of alive neighbors
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if (x != 0 || y != 0) begin
                        int neighbor_row = (i + x + GRID_SIZE) % GRID_SIZE;
                        int neighbor_col = (j + y + GRID_SIZE) % GRID_SIZE;
                        int neighbor_index = (neighbor_row * GRID_SIZE) + neighbor_col;
                        if (current_state[neighbor_index]) begin
                            alive_neighbors = alive_neighbors + 1;
                        end
                    end
                end
            end

            // Apply the Game of Life rules
            if (current_state[index]) begin
                if (alive_neighbors < 2 || alive_neighbors > 3) begin
                    next_state[index] = 1'b0;
                end else begin
                    next_state[index] = 1'b1;
                end
            end else begin
                if (alive_neighbors == 3) begin
                    next_state[index] = 1'b1;
                end else begin
                    next_state[index] = 1'b0;
                end
            end
        end
    end
end

// Sequential logic to update the state
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule