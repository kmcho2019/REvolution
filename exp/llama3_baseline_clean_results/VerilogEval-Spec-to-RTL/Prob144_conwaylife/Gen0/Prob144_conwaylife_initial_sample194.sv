module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, k;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    for (i = 0; i < 256; i = i + 1) begin
        integer row = i / 16;
        integer col = i % 16;
        integer alive_neighbors = 0;

        // Count alive neighbors
        for (j = -1; j <= 1; j = j + 1) begin
            for (k = -1; k <= 1; k = k + 1) begin
                if ((j == 0) && (k == 0)) begin
                    continue;
                end

                integer neighbor_row = (row + j) % 16;
                if (neighbor_row < 0) begin
                    neighbor_row = 15;
                end

                integer neighbor_col = (col + k) % 16;
                if (neighbor_col < 0) begin
                    neighbor_col = 15;
                end

                integer neighbor_index = neighbor_row * 16 + neighbor_col;
                if (current_state[neighbor_index] == 1'b1) begin
                    alive_neighbors = alive_neighbors + 1;
                end
            end
        end

        // Apply game rules
        if (alive_neighbors <= 1) begin
            next_state[i] = 1'b0;
        end else if (alive_neighbors == 2) begin
            next_state[i] = current_state[i];
        end else if (alive_neighbors == 3) begin
            next_state[i] = 1'b1;
        end else begin
            next_state[i] = 1'b0;
        end
    end
end

assign q = current_state;

endmodule