module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

integer i, j, x, y;
reg [7:0] neighbors;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                x = i * 16 + j;
                neighbors = 8'b0;
                for (y = -1; y <= 1; y = y + 1) begin
                    for (x = -1; x <= 1; x = x + 1) begin
                        if ((x == 0) && (y == 0)) begin
                            continue;
                        end else begin
                            if ((q_reg[((i + y + 16) % 16) * 16 + ((j + x + 16) % 16)]) == 1'b1) begin
                                neighbors = neighbors + 1;
                            end
                        end
                    end
                end
                case (neighbors)
                    0, 1: q_reg[x] <= 1'b0;
                    2: q_reg[x] <= q_reg[x];
                    3: q_reg[x] <= 1'b1;
                    default: q_reg[x] <= 1'b0;
                endcase
            end
        end
    end
    q <= q_reg;
end

endmodule