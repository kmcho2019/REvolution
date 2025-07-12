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
        // Corrected shift operation: Shift in the new data bit into the least significant bit position
        q_reg <= {q_reg[2:0], data};
    end else if (count_ena) begin
        // Decrement operation remains the same, as it correctly wraps around when reaching zero
        q_reg <= q_reg - 1;
    end
end

assign q = q_reg;

endmodule