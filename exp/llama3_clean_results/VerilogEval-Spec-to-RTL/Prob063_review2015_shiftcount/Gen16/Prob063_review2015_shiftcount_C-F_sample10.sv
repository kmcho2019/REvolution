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
        // Perform a right shift operation when shift_ena is 1, as in Example 2
        q_reg <= {q_reg[2:0], data};
    end else if (count_ena) begin
        // Decrement the counter when count_ena is 1, using the efficient logic from Example 1
        // The unsigned subtraction will naturally wrap around when q_reg reaches 0
        q_reg <= q_reg - 1;
    end
end

assign q = q_reg;

endmodule