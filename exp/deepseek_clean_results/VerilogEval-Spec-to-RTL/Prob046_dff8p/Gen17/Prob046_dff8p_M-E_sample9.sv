module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

parameter RESET_VAL = 8'h34;  // Reset to 0x34 (00110100)

always @(negedge clk) begin
    if (reset) begin
        // Parallel load of reset value
        q <= RESET_VAL;
    end else begin
        // Normal operation - pass through input
        q <= d;
    end
end

endmodule