module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0;

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift in the data when shift_ena is high
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        // Decrement the counter when count_ena is high and the register is not zero
        q_reg <= (q_reg == 4'b0) ? 4'b0 : q_reg - 1;
    end else begin
        // Do nothing when neither shift_ena nor count_ena is high
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule