module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [255:0] next_state;
        for (int i = 0; i < 256; i++) begin
            reg [2:0] neighbors;
            neighbors = 0;
            // Calculate the row and column of the current cell
            int row = i / 16;
            int col = i % 16;
            // Check the state of the neighboring cells
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        // Skip the current cell
                        continue;
                    end
                    int neighbor_row = (row + x + 16) % 16;
                    int neighbor_col = (col + y + 16) % 16;
                    int neighbor_index = neighbor_row * 16 + neighbor_col;
                    if (q_reg[neighbor_index]) begin
                        neighbors <= neighbors + 1;
                    end
                end
            end
            // Update the state of the current cell based on the number of its neighbors
            case (neighbors)
                3'd0, 3'd1: next_state[i] <= 1'b0;
                3'd2: next_state[i] <= q_reg[i];
                3'd3: next_state[i] <= 1'b1;
                default: next_state[i] <= 1'b0;
            endcase
        end
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule