// Module: TopModule
// Description: A simple D flip-flop with active high synchronous reset.
module TopModule(
    input  clk,  // Clock signal
    input  d,   // Data input
    input  r,   // Reset signal (active high)
    output logic q  // Output
);

// Always block to handle the clock edge and reset
always @(posedge clk) begin
    // Use ternary operator to concisely express the conditional assignment of q
    q <= (r) ? 1'b0 : d;
end

endmodule