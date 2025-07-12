module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg = 8'h34; // Initialize q_reg with the desired reset value

always @(negedge clk) begin
    q_reg <= reset ? 8'h34 : d; // Use conditional operator for concise reset/update logic
end

assign q = q_reg;

endmodule