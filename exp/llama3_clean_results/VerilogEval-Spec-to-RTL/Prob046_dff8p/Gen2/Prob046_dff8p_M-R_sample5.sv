module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg = 8'd52; // Initialize q_reg to 0x34

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'd52; // Reset q_reg to 0x34 on reset
    end else begin
        q_reg <= d; // Update q_reg with d on negative edge of clk
    end
end

assign q = q_reg;

endmodule