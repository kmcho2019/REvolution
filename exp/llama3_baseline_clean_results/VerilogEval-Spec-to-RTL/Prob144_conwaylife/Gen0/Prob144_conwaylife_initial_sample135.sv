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
        for (int i = 0; i < 256; i++) begin
            int row = i / 16;
            int col = i % 16;
            reg [2:0] neighbors;
            neighbors = 0;

            // Check all 8 neighboring positions
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) begin
                        continue;
                    end

                    int new_row = (row + x + 16) % 16;
                    int new_col = (col + y + 16) % 16;
                    int new_idx = new_row * 16 + new_col;

                    neighbors = neighbors + q_reg[new_idx];
                end
            end

            // Update the state of the cell
            if (q_reg[i] == 1) begin
                if (neighbors < 2 || neighbors > 3) begin
                    q_reg[i + 1] <= 0;
                end else begin
                    q_reg[i + 1] <= q_reg[i];
                end
            end else begin
                if (neighbors == 3) begin
                    q_reg[i + 1] <= 1;
                end else begin
                    q_reg[i + 1] <= q_reg[i];
                end
            end
        end
    end
end

assign q = q_reg;

endmodule