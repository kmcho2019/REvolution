module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 0; // Initialize q_reg to 0

always @(posedge clk) begin
    if (shift_ena) begin // Give priority to shift operation
        // Shift in the new data bit and shift out the least significant bit
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        // Decrement q_reg if it is not 0
        if (q_reg > 0) begin
            q_reg <= q_reg - 1;
        end else begin
            // Keep q_reg at 0 if it is already 0
            q_reg <= 0;
        end
    end else begin
        // No operation if neither shift_ena nor count_ena is high
        q_reg <= q_reg; // Keep the current value of q_reg
    end
end

assign q = q_reg;

endmodule