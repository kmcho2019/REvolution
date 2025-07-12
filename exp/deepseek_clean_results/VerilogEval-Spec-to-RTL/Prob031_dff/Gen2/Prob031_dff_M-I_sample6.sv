module TopModule (
    input  wire clk,    // Positive edge-trigger clock
    input  wire d,      // Data input
    output reg  q,      // Data output
    input  wire rst_n   // Asynchronous active-low reset (optional)
);

// Positive edge-triggered D flip-flop with asynchronous reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 1'b0;      // Reset to 0 when reset is active
    end else begin
        q <= d;         // Normal operation
    end
end

endmodule