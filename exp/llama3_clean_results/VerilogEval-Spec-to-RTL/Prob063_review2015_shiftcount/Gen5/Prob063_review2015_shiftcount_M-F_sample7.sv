module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    // Check for shift enable signal
    if (shift_ena) begin
        // Shift in the new data bit
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        // Decrement the value if it's greater than 0
        if (q_reg > 0) begin
            q_reg <= q_reg - 1;
        end else begin
            // If the value is 0, keep it at 0 to avoid underflow
            q_reg <= 4'b0;
        end
    end else begin
        // If neither shift_ena nor count_ena is high, hold the value constant
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule