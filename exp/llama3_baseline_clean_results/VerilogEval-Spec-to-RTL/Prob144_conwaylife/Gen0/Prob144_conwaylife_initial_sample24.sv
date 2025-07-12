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
        for (int i = 0; i < 256; i++) begin
            reg [2:0] neighbors;
            for (int j = 0; j < 8; j++) begin
                reg [7:0] x, y;
                case (j)
                    0: begin x = (i % 16) + 1; y = (i / 16); end
                    1: begin x = (i % 16); y = (i / 16) + 1; end
                    2: begin x = (i % 16) - 1; y = (i / 16) + 1; end
                    3: begin x = (i % 16) - 1; y = (i / 16); end
                    4: begin x = (i % 16) - 1; y = (i / 16) - 1; end
                    5: begin x = (i % 16); y = (i / 16) - 1; end
                    6: begin x = (i % 16) + 1; y = (i / 16) - 1; end
                    7: begin x = (i % 16) + 1; y = (i / 16); end
                endcase
                if (x == 16) x = 0;
                if (x == -1) x = 15;
                if (y == 16) y = 0;
                if (y == -1) y = 15;
                neighbors = neighbors + q_reg[(y * 16) + x];
            end
            case (neighbors)
                0, 1: next_q[i] = 0;
                2: next_q[i] = q_reg[i];
                3: next_q[i] = 1;
                default: next_q[i] = 0;
            endcase
        end
        q_reg <= next_q;
    end
end

assign q = q_reg;

endmodule