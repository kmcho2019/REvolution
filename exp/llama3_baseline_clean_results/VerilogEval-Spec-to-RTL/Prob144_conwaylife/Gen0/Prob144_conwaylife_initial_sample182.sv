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
            int alive_neighbors = 0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;
                    int neighbor_x = (i % 16 + x + 16) % 16;
                    int neighbor_y = (i / 16 + y + 16) % 16;
                    int neighbor_index = neighbor_y * 16 + neighbor_x;
                    if (q_reg[neighbor_index]) begin
                        alive_neighbors++;
                    end
                end
            end
            if (alive_neighbors < 2 || alive_neighbors > 3) begin
                q_reg[i] <= 1'b0;
            end else if (alive_neighbors == 3) begin
                q_reg[i] <= 1'b1;
            end
        end
    end
end

assign q = q_reg;

endmodule