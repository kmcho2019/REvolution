module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;
integer i, j, x, y;
reg [2:0] neighbors;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                neighbors = 0;
                for (x = -1; x <= 1; x = x + 1) begin
                    for (y = -1; y <= 1; y = y + 1) begin
                        if ((x != 0 || y != 0) && (q_reg[((i + x + 16) % 16) * 16 + j + y + 16] == 1'b1)) begin
                            neighbors = neighbors + 1;
                        end
                    end
                end
                if (neighbors < 2 || neighbors > 3) begin
                    q_reg[i * 16 + j] <= 1'b0;
                end else if (neighbors == 3) begin
                    q_reg[i * 16 + j] <= 1'b1;
                end
            end
        end
    end
end

assign q = q_reg;

endmodule