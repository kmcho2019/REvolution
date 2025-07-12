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
        reg [255:0] next_q;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] alive_neighbors;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        reg [7:0] neighbor_i;
                        reg [7:0] neighbor_j;
                        neighbor_i = (i + x + 16) % 16;
                        neighbor_j = (j + y + 16) % 16;
                        if (q_reg[neighbor_i * 16 + neighbor_j]) begin
                            alive_neighbors <= alive_neighbors + 1;
                        end
                    end
                end
                case (alive_neighbors)
                    3'd0, 3'd1: next_q[i * 16 + j] <= 1'b0;
                    3'd2: next_q[i * 16 + j] <= q_reg[i * 16 + j];
                    3'd3: next_q[i * 16 + j] <= 1'b1;
                    default: next_q[i * 16 + j] <= 1'b0;
                endcase
            end
        end
        q_reg <= next_q;
    end
end

assign q = q_reg;

endmodule