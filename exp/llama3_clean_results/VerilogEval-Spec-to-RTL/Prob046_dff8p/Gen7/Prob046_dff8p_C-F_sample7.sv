module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

initial q = 8'h34; // Initialize q with the desired reset value

always @(negedge clk) begin
    q <= reset ? 8'h34 : d; // Use conditional operator for concise reset/update logic
end

endmodule