module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @ (posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [255:0] next_q;
        for (int i = 0; i < 256; i++) begin
            int row = i / 16;
            int col = i % 16;
            int alive_neighbors = 0;

            // Calculate the number of alive neighbors
            for (int j = -1; j <= 1; j++) begin
                for (int k = -1; k <= 1; k++) begin
                    if (j == 0 && k == 0) begin
                        continue;
                    end
                    int neighbor_row = (row + j + 16) % 16;
                    int neighbor_col = (col + k + 16) % 16;
                    int neighbor_index = neighbor_row * 16 + neighbor_col;
                    alive_neighbors += q_reg[neighbor_index];
                end
            end

            // Update the state of the cell
            if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
                next_q[i] <= 1'b0;
            end else if (alive_neighbors == 2) begin
                next_q[i] <= q_reg[i];
            end else if (alive_neighbors == 3) begin
                next_q[i] <= 1'b1;
            end
        end
        q_reg <= next_q;
    end
end

assign q = q_reg;

endmodule