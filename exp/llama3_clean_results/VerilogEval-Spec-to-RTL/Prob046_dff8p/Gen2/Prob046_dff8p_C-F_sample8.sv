module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg = 8'h34; // Initialize q_reg to 0x34 for clarity

assign q = q_reg; // Continuously assign q_reg to output q

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34; // Synchronous reset to 0x34 on reset
    end else begin
        q_reg <= d; // Update q_reg with d on negative edge of clk
    end
end

endmodule