// Optimized D flip-flop with synchronous reset and clock gating
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] d_prev;
wire clk_enable;

// Detect when input changes to enable clock gating
assign clk_enable = (d != d_prev) || reset;

always @(posedge clk) begin
    d_prev <= d;  // Store previous input for comparison
    
    if (clk_enable) begin
        if (reset) q <= 8'b0;  // Synchronous reset
        else q <= d;           // Normal operation
    end
end

endmodule