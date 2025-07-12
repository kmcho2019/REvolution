module TopModule(
    input  clk, // Clock signal
    input  d,   // Data input
    input  r,   // Active high synchronous reset
    output reg q // Output, initialized to 0 for simplicity
);

// Initialize q to 0 for a defined starting state in simulation
initial q = 1'b0;

always @(posedge clk) begin
    // Use the ternary operator for concise conditional assignment
    q <= (r) ? 1'b0 : d;
end

endmodule