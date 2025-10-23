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
        // Perform a right shift operation when shift_ena is 1
        // Prevent overflow by checking the most significant bit before shifting
        if (q_reg[3] == 1'b1) begin
            q_reg <= {1'b0, q_reg[2:0], data}; // Shift and prevent overflow
        end else begin
            q_reg <= {q_reg[2:0], data};
        end
    end else if (count_ena) begin
        // Implement decrement operation using the shift register itself
        if (q_reg == 4'b0000) begin
            q_reg <= 4'b1111; // Wrap around when reaching 0
        end else begin
            // Simulate borrow by inverting the most significant bit if it's 1
            q_reg <= {~q_reg[3] & (q_reg[3] == 1'b1), q_reg[2:0]} - 1'b1;
        end
    end
end

assign q = q_reg;

endmodule