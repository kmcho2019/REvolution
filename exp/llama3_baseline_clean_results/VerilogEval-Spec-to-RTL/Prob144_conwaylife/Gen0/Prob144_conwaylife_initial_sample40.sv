module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, x, y, neighbor_count;

always @(*) begin
    for (i = 0; i < 256; i = i + 1) begin
        x = i % 16;
        y = i / 16;
        neighbor_count = 0;

        // Count the number of alive neighbors
        for (j = -1; j <= 1; j = j + 1) begin
            for (x = -1; x <= 1; x = x + 1) begin
                if ((x == 0) && (j == 0)) begin
                    // Don't count the cell itself
                    continue;
                end else begin
                    // Calculate the index of the neighboring cell
                    integer neighbor_x = (x + i % 16) % 16;
                    integer neighbor_y = (j + i / 16) % 16;
                    integer neighbor_index = neighbor_y * 16 + neighbor_x;

                    // Check if the neighboring cell is alive
                    if (current_state[neighbor_index]) begin
                        neighbor_count = neighbor_count + 1;
                    end
                end
            end
        end

        // Determine the next state of the cell based on the number of alive neighbors
        if (neighbor_count <= 1) begin
            next_state[i] = 1'b0;
        end else if (neighbor_count == 2) begin
            next_state[i] = current_state[i];
        end else if (neighbor_count == 3) begin
            next_state[i] = 1'b1;
        end else begin
            next_state[i] = 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule