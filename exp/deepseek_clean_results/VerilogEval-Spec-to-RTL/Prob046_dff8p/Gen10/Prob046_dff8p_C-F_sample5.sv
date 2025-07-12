module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Reset value is 0x34 (binary: 00110100)
localparam RESET_VAL = 8'h34;

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;  // Synchronous reset to 0x34 on negative edge
    end else begin
        q <= d;         // Normal operation: capture input on negative edge
    end
end

endmodule