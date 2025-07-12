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
        // Only update if the new data is different from the current least significant bit
        if (data != q_reg[0]) begin
            q_reg <= {q_reg[2:0], data};
        end
    end else if (count_ena) begin
        // Decrement the counter using bitwise operations for potential area reduction
        if (q_reg == 4'b0000) begin
            q_reg <= 4'b1111; // Wrap around to 15 when decrementing from 0
        end else begin
            q_reg <= q_reg - 1'b1; // Decrement by 1
        end
    end
end

assign q = q_reg;

endmodule