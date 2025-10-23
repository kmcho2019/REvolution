module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;
reg [255:0] q_next;

integer i, j, k;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q_next;
    end
end

always @(*) begin
    q_next = q_reg;
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            reg [2:0] alive_neighbors;
            alive_neighbors = 0;
            for (k = 0; k < 8; k++) begin
                reg x, y;
                case (k)
                    0: x = (i - 1 + 16) % 16; y = (j - 1 + 16) % 16;
                    1: x = (i + 16) % 16; y = (j - 1 + 16) % 16;
                    2: x = (i + 1 + 16) % 16; y = (j - 1 + 16) % 16;
                    3: x = (i + 1 + 16) % 16; y = (j + 16) % 16;
                    4: x = (i + 1 + 16) % 16; y = (j + 1 + 16) % 16;
                    5: x = (i + 16) % 16; y = (j + 1 + 16) % 16;
                    6: x = (i - 1 + 16) % 16; y = (j + 1 + 16) % 16;
                    7: x = (i - 1 + 16) % 16; y = (j + 16) % 16;
                endcase
                if (q_reg[(x * 16) + y]) begin
                    alive_neighbors = alive_neighbors + 1;
                end
            end
            case (alive_neighbors)
                0, 1: q_next[(i * 16) + j] = 1'b0;
                2: q_next[(i * 16) + j] = q_reg[(i * 16) + j];
                3: q_next[(i * 16) + j] = 1'b1;
                default: q_next[(i * 16) + j] = 1'b0;
            endcase
        end
    end
end

assign q = q_reg;

endmodule