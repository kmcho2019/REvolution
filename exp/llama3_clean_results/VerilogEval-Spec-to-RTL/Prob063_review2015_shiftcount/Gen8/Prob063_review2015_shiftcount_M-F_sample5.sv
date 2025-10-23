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
        q_reg <= {data, q_reg[3:1]}; // Shift in the new data bit
    end else if (count_ena) begin
        if (q_reg == 0) begin
            q_reg <= 0; // Handle the case where q_reg is 0 correctly
        end else begin
            q_reg <= q_reg - 1; // Decrement q_reg by 1
        end
    end else begin
        // No operation if neither shift_ena nor count_ena is high
        q_reg <= q_reg; // Hold the current value of q_reg
    end
end

assign q = q_reg;

endmodule