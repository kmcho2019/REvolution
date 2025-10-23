module TopModule (
    input  wire clk,  // Clock input
    input  wire d,    // Data input
    output reg  q     // Registered output
);

// Positive edge-triggered D flip-flop
always @(posedge clk) begin
    q <= d;
end

endmodule