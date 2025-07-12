module TopModule (
    input  wire clk,  // System clock (positive edge-triggered)
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output reg  q     // Registered output
);

// Positive edge-triggered D flip-flop with async reset
// Note: Clock gating could be added here if 'd' is stable for long periods
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;    // Async reset (highest priority)
    end else begin
        q <= d;       // Normal data capture on rising clock edge
    end
end

endmodule