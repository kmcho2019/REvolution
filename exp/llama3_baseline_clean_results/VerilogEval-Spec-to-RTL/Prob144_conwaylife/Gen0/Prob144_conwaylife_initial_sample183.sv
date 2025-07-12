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
        reg [255:0] new_q;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] neighbors;
                neighbors = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if (x == 0 && y == 0) continue;
                        reg [7:0] row, col;
                        row = (i + x) % 16;
                        col = (j + y) % 16;
                        reg index;
                        index = row * 16 + col;
                        neighbors += q_reg[index];
                    end
                end
                reg new_state;
                case (neighbors)
                    3'd0, 3'd1: new_state = 1'b0;
                    3'd2: new_state = q_reg[i * 16 + j];
                    3'd3: new_state = 1'b1;
                    default: new_state = 1'b0;
                endcase
                new_q[i * 16 + j] = new_state;
            end
        end
        q_reg <= new_q;
    end
end

assign q = q_reg;

endmodule