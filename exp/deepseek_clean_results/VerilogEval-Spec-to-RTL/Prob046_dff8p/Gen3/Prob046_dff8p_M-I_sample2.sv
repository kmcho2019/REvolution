module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Clock gating control
wire clk_enable = reset || (q != d);

// Gated clock
wire gated_clk;
assign gated_clk = clk & clk_enable;

// Main flip-flop logic
always @(negedge gated_clk) begin
    if (reset) begin
        q <= 8'h34;  // Reset to 0x34 (00110100)
    end else begin
        q <= d;      // Normal operation
    end
end

endmodule