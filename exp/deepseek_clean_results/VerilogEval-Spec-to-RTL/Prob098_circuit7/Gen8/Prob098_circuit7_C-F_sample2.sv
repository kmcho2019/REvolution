module TopModule (
    input clk,    // System clock
    input a,      // Input signal
    output reg q   // Registered output
);

// Parameter for initialization value (not used in logic)
parameter INIT_VAL = 1'b0;

// Synchronous logic with clear behavior
always @(posedge clk) begin
    q <= ~a;  // Output is inverted input sampled at clock edge
end

// Initialize output (simulation only)
initial begin
    q = INIT_VAL;
end

endmodule