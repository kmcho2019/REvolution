module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

// Directly compute the next state of q_reg based on current state and control signals
always @(posedge clk) begin
    if (shift_ena) begin
        // Priority given to shift operation when both shift_ena and count_ena are high
        q_reg <= {q_reg[2:0], data};
    end else if (count_ena) begin
        // Decrement the counter, using a bitwise approach for potential synthesis efficiency
        q_reg <= (q_reg == 0) ? 0 : q_reg - 1;
    end else begin
        // If neither shift_ena nor count_ena is high, maintain the current state
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule