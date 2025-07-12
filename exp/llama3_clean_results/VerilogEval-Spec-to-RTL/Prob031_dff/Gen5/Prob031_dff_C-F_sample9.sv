// Superior solution combining the strengths of both examples
module TopModule(
    input clk, // Clock signal
    input d,   // Data input
    output reg q // Output of the D flip-flop
);

// Initialize q to a default value for a defined startup state
initial q = 1'b0;

// Always block triggered on the positive edge of the clock
always @(posedge clk) begin
    // Non-blocking assignment to ensure proper sequential logic behavior
    q <= d;
end

endmodule