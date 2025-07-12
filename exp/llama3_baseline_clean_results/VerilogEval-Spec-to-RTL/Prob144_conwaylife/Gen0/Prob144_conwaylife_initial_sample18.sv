module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

integer i, j;
reg [7:0] neighbors;
reg [255:0] q_next;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q_next;
    end
end

always @(*) begin
    q_next = 256'd0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            neighbors = 8'd0;
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if ((x != 0 || y != 0) && ((i + x + 16) % 16 == (i + x)) && ((j + y + 16) % 16 == (j + y))) begin
                        neighbors = neighbors + q_reg[((i + x + 16) % 16) * 16 + (j + y + 16) % 16];
                    end else if ((x != 0 || y != 0)) begin
                        neighbors = neighbors + q_reg[((i + x + 16) % 16) * 16 + (j + y + 16) % 16];
                    end
                end
            end
            if (q_reg[i * 16 + j] == 1'b1) begin
                if (neighbors == 2 || neighbors == 3) begin
                    q_next[i * 16 + j] = 1'b1;
                end else begin
                    q_next[i * 16 + j] = 1'b0;
                end
            end else begin
                if (neighbors == 3) begin
                    q_next[i * 16 + j] = 1'b1;
                end else begin
                    q_next[i * 16 + j] = 1'b0;
                end
            end
        end
    end
end

assign q = q_reg;

endmodule