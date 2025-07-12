module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q = 1'b0  // Output with explicit reset value
);

// Combinational logic for next state
wire next_q = r ? 1'b0 : d;

// Positive edge-triggered D flip-flop
always @(posedge clk) begin
    q <= next_q;
end

endmodule