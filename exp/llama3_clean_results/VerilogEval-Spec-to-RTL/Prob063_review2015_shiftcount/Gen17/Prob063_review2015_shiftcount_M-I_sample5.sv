module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

// Simplify the logic within the always block
always @(posedge clk) begin
    if (shift_ena) begin
        // Shift operation
        q_reg <= {q_reg[2:0], data};
    end else if (count_ena) begin
        // Decrement operation using bitwise operations
        q_reg <= (q_reg == 4'b0)? 4'b0 : q_reg - 1;
    end else begin
        // Maintain the current state
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule