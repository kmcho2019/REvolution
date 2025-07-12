module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0000; // Initialize q_reg to 0

always @(posedge clk) begin
    if (shift_ena) begin
        // Shift in the new data bit most-significant-bit first
        q_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        // Decrement q_reg by 1 if it's not already 0
        if (q_reg != 0) begin
            q_reg <= q_reg - 1;
        end
    end
end

assign q = q_reg;

endmodule