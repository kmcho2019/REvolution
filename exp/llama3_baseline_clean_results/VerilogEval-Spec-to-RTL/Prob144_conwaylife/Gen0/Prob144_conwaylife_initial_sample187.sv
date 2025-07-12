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
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                int neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        int idx_x = (i + x + 16) % 16;
                        int idx_y = (j + y + 16) % 16;
                        int idx = idx_x * 16 + idx_y;
                        neighbors += q_reg[idx];
                    end
                end
                if (neighbors == 2) begin
                    // do nothing
                end else if (neighbors == 3) begin
                    q_reg[i * 16 + j] <= 1'b1;
                end else begin
                    q_reg[i * 16 + j] <= 1'b0;
                end
            end
        end
    end
end

assign q = q_reg;

endmodule