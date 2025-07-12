module TopModule (
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
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int num_neighbors = 0;
                // Count neighbors
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) begin
                            // Skip the current cell
                            continue;
                        end
                        int neighbor_x = (i + x + 16) % 16;
                        int neighbor_y = (j + y + 16) % 16;
                        int index = neighbor_x * 16 + neighbor_y;
                        if (q_reg[index]) begin
                            num_neighbors++;
                        end
                    end
                end
                // Apply game rules
                if (num_neighbors <= 1 || num_neighbors >= 4) begin
                    q_reg[i * 16 + j] <= 0;
                end else if (num_neighbors == 3) begin
                    q_reg[i * 16 + j] <= 1;
                end else begin
                    // num_neighbors == 2, keep the current state
                end
            end
        end
    end
end

assign q = q_reg;

endmodule