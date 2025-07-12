module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to a default state
);

always @(posedge clk) begin
    // Determine the next state of Q based on the current state and inputs
    // Commenting each condition for clarity
    // If both j and k are 0, Q remains the same
    // If j is 0 and k is 1, Q becomes 0
    // If j is 1 and k is 0, Q becomes 1
    // If both j and k are 1, Q becomes the inverse of its current state
    Q <= (~j & ~k)? Q : // No change
         (~j & k)? 1'b0 : // Reset
         (j & ~k)? 1'b1 : // Set
         (~Q); // Toggle
end

endmodule