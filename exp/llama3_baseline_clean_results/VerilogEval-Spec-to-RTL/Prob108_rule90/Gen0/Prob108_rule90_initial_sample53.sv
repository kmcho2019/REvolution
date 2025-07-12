module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            if (i == 0) begin
                q_reg[i] <= 1'b0 ^ data[i] ^ (i + 1 < 512 ? data[i + 1] : 1'b0);
            end else if (i == 511) begin
                q_reg[i] <= (i - 1 >= 0 ? data[i - 1] : 1'b0) ^ data[i] ^ 1'b0;
            end else begin
                q_reg[i] <= data[i - 1] ^ data[i] ^ data[i + 1];
            end
        end
    end
end

assign q = q_reg;

endmodule