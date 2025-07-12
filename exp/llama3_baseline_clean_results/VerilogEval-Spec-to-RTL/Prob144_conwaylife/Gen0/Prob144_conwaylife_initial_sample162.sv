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
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] neighbors;
                neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) begin
                            continue;
                        end
                        reg [7:0] row, col;
                        row = (i + x + 16) % 16;
                        col = (j + y + 16) % 16;
                        neighbors += q_reg[(row * 16) + col];
                    end
                end
                case (neighbors)
                    3'd0, 3'd1: next_state[(i * 16) + j] <= 1'b0;
                    3'd2: next_state[(i * 16) + j] <= q_reg[(i * 16) + j];
                    3'd3: next_state[(i * 16) + j] <= 1'b1;
                    default: next_state[(i * 16) + j] <= 1'b0;
                endcase
            end
        end
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule