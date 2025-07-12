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
        // Perform a left shift operation when shift_ena is 1 to shift data in most-significant-bit first
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        // Decrement the counter when count_ena is 1, using efficient logic
        q_reg <= q_reg - 1;
    end else begin
        // Maintain the current state if neither shift_ena nor count_ena is high
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule