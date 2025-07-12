module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(negedge clk) begin
    q <= reset ? 8'h34 : d;  // Ternary operator for concise reset logic
end

endmodule