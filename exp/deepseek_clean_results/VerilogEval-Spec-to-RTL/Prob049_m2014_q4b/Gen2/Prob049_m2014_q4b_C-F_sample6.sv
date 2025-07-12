module TopModule (
    input  clk,    // Clock input (positive edge triggered)
    input  ar,     // Asynchronous reset (active high)
    input  d,      // Data input
    output reg q   // Data output
);

// Positive edge-triggered D flip-flop with asynchronous reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;  // Asynchronous clear when reset is active
    end else begin
        q <= d;     // Capture input on rising clock edge
    end
end

endmodule