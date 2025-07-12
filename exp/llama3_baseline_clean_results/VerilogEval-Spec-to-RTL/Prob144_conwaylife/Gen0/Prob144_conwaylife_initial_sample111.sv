module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;
integer i, j, x, y, neighbor_count;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                neighbor_count = 0;
                for (x = -1; x <= 1; x++) begin
                    for (y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue; // skip self
                        if (q_reg[(i + x + 16) % 16 * 16 + (j + y + 16) % 16] == 1'b1) begin
                            neighbor_count = neighbor_count + 1;
                        end
                    end
                end
                case (neighbor_count)
                    0, 1: q_reg[i * 16 + j] <= 1'b0;
                    2: q_reg[i * 16 + j] <= q_reg[i * 16 + j];
                    3: q_reg[i * 16 + j] <= 1'b1;
                    default: q_reg[i * 16 + j] <= 1'b0;
                endcase
            end
        end
    end
end

assign q = q_reg;

endmodule