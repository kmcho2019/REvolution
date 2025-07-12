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
                int neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        int nx = (i + x + 16) % 16;
                        int ny = (j + y + 16) % 16;
                        int idx = nx * 16 + ny;
                        neighbors += q_reg[idx];
                    end
                end
                if (neighbors <= 1 || neighbors >= 4) begin
                    q_reg[i * 16 + j] <= 0;
                end else if (neighbors == 2) begin
                    q_reg[i * 16 + j] <= q_reg[i * 16 + j];
                end else if (neighbors == 3) begin
                    q_reg[i * 16 + j] <= 1;
                end
            end
        end
    end
end

assign q = q_reg;

endmodule