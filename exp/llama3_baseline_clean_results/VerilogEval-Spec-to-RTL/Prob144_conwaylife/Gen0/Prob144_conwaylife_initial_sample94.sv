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
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] neighbor_count;
                neighbor_count = 0;

                // Count neighbors
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;

                        int neighbor_i = (i + x + 16) % 16;
                        int neighbor_j = (j + y + 16) % 16;

                        if (q_reg[neighbor_i*16 + neighbor_j]) begin
                            neighbor_count <= neighbor_count + 1;
                        end
                    end
                end

                // Apply game rules
                if (neighbor_count <= 1) begin
                    q_reg[i*16 + j] <= 0;
                end else if (neighbor_count == 2) begin
                    // No change
                end else if (neighbor_count == 3) begin
                    q_reg[i*16 + j] <= 1;
                end else begin
                    q_reg[i*16 + j] <= 0;
                end
            end
        end
    end
end

assign q = q_reg;

endmodule