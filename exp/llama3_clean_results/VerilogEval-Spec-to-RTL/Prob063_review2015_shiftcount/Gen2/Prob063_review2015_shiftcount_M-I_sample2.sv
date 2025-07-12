module TopModule(
    input clk,
    input reset, // Added reset signal
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'd0; // Initialize q_reg to 0

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 4'd0; // Reset q_reg to 0 on reset
    end else if (shift_ena) begin
        q_reg <= {data, q_reg[3:1]};  // Shift data into the most significant bit
    end else if (count_ena) begin
        if (q_reg == 4'd0) begin
            q_reg <= 4'd0; // Handle decrement when q_reg is 0
        end else begin
            q_reg <= q_reg - 1;  // Decrement the register value
        end
    end
end

assign q = q_reg;

endmodule