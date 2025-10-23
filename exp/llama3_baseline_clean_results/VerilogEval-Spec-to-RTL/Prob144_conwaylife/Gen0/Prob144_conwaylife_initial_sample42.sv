module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, x, y;

// Load initial state into current_state at the next clock edge
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

// Update next_state based on current_state
always @(*) begin
    next_state = 256'b0;
    for (i = 0; i < 256; i++) begin
        x = i % 16;
        y = i / 16;
        integer alive_neighbors = 0;

        // Count alive neighbors
        for (j = -1; j <= 1; j++) begin
            for (integer k = -1; k <= 1; k++) begin
                if (j == 0 && k == 0) begin
                    continue;
                end
                integer nx = (x + j + 16) % 16;
                integer ny = (y + k + 16) % 16;
                integer neighbor_index = ny * 16 + nx;
                if (current_state[neighbor_index]) begin
                    alive_neighbors++;
                end
            end
        end

        // Update next_state based on the number of alive neighbors
        if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
            next_state[i] = 1'b0;
        end else if (alive_neighbors == 2) begin
            next_state[i] = current_state[i];
        end else if (alive_neighbors == 3) begin
            next_state[i] = 1'b1;
        end
    end
end

// Assign output q
assign q = current_state;

endmodule