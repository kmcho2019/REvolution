module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

// Initialize current_state with data on load signal
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to compute next_state
always @(*) begin
    next_state = 256'b0;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            // Calculate alive neighbors
            reg [2:0] alive_neighbors;
            alive_neighbors = 3'b0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) begin
                        // Skip self
                        continue;
                    end
                    int neighbor_i = (i + x + 16) % 16;
                    int neighbor_j = (j + y + 16) % 16;
                    if (current_state[neighbor_i * 16 + neighbor_j]) begin
                        alive_neighbors = alive_neighbors + 1'b1;
                    end
                end
            end
            // Apply game rules
            if (current_state[i * 16 + j]) begin
                // Cell is alive
                if (alive_neighbors == 2'b0 || alive_neighbors == 2'b1) begin
                    // Cell dies
                    next_state[i * 16 + j] = 1'b0;
                end else if (alive_neighbors == 2'b10) begin
                    // Cell dies
                    next_state[i * 16 + j] = 1'b0;
                end else begin
                    // Cell stays alive
                    next_state[i * 16 + j] = 1'b1;
                end
            end else begin
                // Cell is dead
                if (alive_neighbors == 3'b11) begin
                    // Cell becomes alive
                    next_state[i * 16 + j] = 1'b1;
                end else begin
                    // Cell stays dead
                    next_state[i * 16 + j] = 1'b0;
                end
            end
        end
    end
end

// Assign output
assign q = current_state;

endmodule