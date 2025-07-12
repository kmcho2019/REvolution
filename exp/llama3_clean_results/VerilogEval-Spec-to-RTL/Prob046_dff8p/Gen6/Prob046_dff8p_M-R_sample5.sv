module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg = 8'd52; // Initialize q_reg to 0x34 (52 in decimal)

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'd52; // Reset to 0x34
    end else begin
        q_reg <= d; // Assign d to q_reg on the negative edge of clk
    end
end

assign q = q_reg; // Continuous assignment to output q

endmodule