// Refactored version of TopModule focusing on readability and explicit initial condition
module TopModule(
    input clk, // Clock signal
    input d,   // Data input
    output reg q = 1'b0 // Output of the D flip-flop, initialized to 0
);

// Always block triggered on the positive edge of the clock
always @(posedge clk) begin
    // Non-blocking assignment to ensure proper sequential logic behavior
    q <= d; // Capture data input on the rising edge of the clock
end

endmodule