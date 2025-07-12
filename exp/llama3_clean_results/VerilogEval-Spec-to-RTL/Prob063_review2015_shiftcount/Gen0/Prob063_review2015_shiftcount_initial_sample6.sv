module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    if (shift_ena) begin
        q_reg[3] <= data;
        q_reg[2:0] <= q_reg[3:1];
    end else if (count_ena) begin
        if (q_reg == 0) begin
            q_reg <= 4'd0;
        end else begin
            q_reg <= q_reg - 1'b1;
        end
    end
end

assign q = q_reg;

endmodule