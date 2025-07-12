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
            int row = i / 16;
            int col = i % 16;
            int alive_neighbors = 0;
            // Count alive neighbors
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x != 0 || y != 0)) begin
                        int n_row = (row + x + 16) % 16;
                        int n_col = (col + y + 16) % 16;
                        int n_index = n_row * 16 + n_col;
                        if (q_reg[n_index]) begin
                            alive_neighbors++;
                        end
                    end
                end
            end
            // Update cell state
            case (alive_neighbors)
                0, 1: next_state[i] = 0;
                2: next_state[i] = q_reg[i];
                3: next_state[i] = 1;
                default: next_state[i] = 0;
            endcase
        end
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule