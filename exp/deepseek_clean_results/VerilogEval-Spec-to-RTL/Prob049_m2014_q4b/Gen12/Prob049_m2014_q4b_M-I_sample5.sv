module TopModule (
    input  wire clk,    // Clock input
    input  wire ar,     // Asynchronous reset (active high)
    input  wire d,      // Data input
    output reg  q       // Data output
);

parameter RESET_VAL = 1'b0;  // Default reset value

// Clock gating logic
wire gated_clk;
reg d_prev;
assign gated_clk = (d != d_prev) ? clk : 1'b0;

// Compact flip-flop implementation with async reset
always @(posedge gated_clk or posedge ar) begin
    if (ar) begin
        q <= RESET_VAL;      // Async reset has priority
        d_prev <= RESET_VAL; // Reset tracking register
    end else begin
        q <= d;              // Normal operation
        d_prev <= d;        // Track previous input
    end
end

endmodule