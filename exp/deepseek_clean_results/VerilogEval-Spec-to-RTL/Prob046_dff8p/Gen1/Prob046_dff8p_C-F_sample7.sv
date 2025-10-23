module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

parameter RESET_VAL = 8'h34;  // Clear hexadecimal specification of reset value

always @(negedge clk) begin
    q <= reset ? RESET_VAL : d;  // Compact conditional assignment
end

endmodule