module TopModule (
    input  wire clk,  // Positive edge-trigger clock
    input  wire d,    // Data input
    output reg  q     // Data output
);

// Positive edge-triggered D flip-flop
always @(posedge clk) begin
    q <= d;
end

endmodule