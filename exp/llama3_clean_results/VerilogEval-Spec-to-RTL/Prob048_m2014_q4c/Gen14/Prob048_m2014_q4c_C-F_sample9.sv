module TopModule(
    input  logic clk,  // Clock signal
    input  logic d,    // Data input
    input  logic r,    // Reset signal (active high)
    output logic q      // Output
);

// Using a synchronous reset with a ternary operator for concise expression
always @(posedge clk) begin
    // Reset output to 0 when r is high, otherwise load input data
    q <= r ? 1'b0 : d;
end

endmodule