// Improved version of TopModule with optimization considerations
module TopModule(
    input clk, // Clock signal
    input d,   // Data input
    output reg q // Output of the D flip-flop
);

// Always block triggered on the positive edge of the clock
always @(posedge clk) begin
    // Non-blocking assignment to ensure proper sequential logic behavior
    q <= d;
end

endmodule