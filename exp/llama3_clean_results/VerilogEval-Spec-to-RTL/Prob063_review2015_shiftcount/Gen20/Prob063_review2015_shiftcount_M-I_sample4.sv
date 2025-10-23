module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
reg data_prev; // Register to store previous data value

always @(posedge clk) begin
    if (shift_ena) begin
        // Check if data has changed before shifting
        if (data != data_prev) begin
            q_reg <= {q_reg[2:0], data};
            data_prev <= data; // Update previous data
        end
    end else if (count_ena) begin
        // Decrement operation remains the same for simplicity and efficiency
        if (q_reg == 0) begin
            q_reg <= 4'b1111; // Wrap around when reaching zero
        end else begin
            q_reg <= q_reg - 1;
        end
    end
end

assign q = q_reg;

endmodule