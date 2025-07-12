module TopModule (
    input  clk,    // Clock input
    input  ar,     // Asynchronous reset (active-high)
    input  d,      // Data input
    output reg q = 1'b0  // Output flip-flop with explicit reset value
);

// Positive-edge triggered DFF with async active-high reset
always @(posedge clk or posedge ar) begin
    if (ar) q <= 1'b0;  // Reset takes precedence
    else    q <= d;     // Normal operation
end

endmodule