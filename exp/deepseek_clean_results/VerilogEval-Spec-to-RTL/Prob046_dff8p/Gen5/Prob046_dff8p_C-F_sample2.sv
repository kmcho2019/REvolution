module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

localparam RESET_VAL = 8'h34;  // Clear hexadecimal notation for reset value

always @(negedge clk) begin
    q <= reset ? RESET_VAL : d;  // Compact yet readable reset logic
end

endmodule