module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(negedge clk) begin
    if (reset) begin
        // Reset q_reg to the specified value on reset
        q_reg <= 8'h34;
    end else begin
        // Load d into q_reg on the negative edge of clk
        q_reg <= d;
    end
end

// Continuous assignment to output q
assign q = q_reg;

endmodule