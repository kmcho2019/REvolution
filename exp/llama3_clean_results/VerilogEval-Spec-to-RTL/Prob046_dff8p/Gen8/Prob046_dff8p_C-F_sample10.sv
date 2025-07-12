module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

parameter RESET_VALUE = 8'h34; // Define the reset value as a parameter

initial q = RESET_VALUE; // Initialize q with the desired reset value

always @(negedge clk) begin
    q <= reset? RESET_VALUE : d; // Use conditional operator for concise reset/update logic
end

endmodule