module TopModule (
    input  wire clk,  // Positive edge-triggered clock
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output reg  q     // Registered output
);

// Positive edge-triggered D flip-flop with async reset
always @(posedge clk or posedge ar) begin
    if (ar) q <= 1'b0;  // Async reset has highest priority
    else    q <= d;     // Normal operation: capture input on rising clock edge
end

endmodule