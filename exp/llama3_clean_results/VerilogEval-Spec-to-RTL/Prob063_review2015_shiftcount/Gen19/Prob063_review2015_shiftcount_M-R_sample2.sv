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
        // Shift operation
        q_reg <= {q_reg[2:0], data};
    end else if (count_ena) begin
        // Decrement operation, using subtraction for simplicity
        // Note: This could potentially be optimized further for specific target technologies
        q_reg <= (q_reg == 0) ? 0 : q_reg - 1;
    end else begin
        // No operation, maintain current state
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule