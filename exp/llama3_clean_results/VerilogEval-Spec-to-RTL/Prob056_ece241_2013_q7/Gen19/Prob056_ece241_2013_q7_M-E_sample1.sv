module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 1'b0 // Initialize Q to a default state
);

reg Qold; // Store the previous state of Q

always @(*) begin
    Qold = Q; // Update Qold with the current state of Q
end

always @(posedge clk) begin
    if (~j & ~k) Q <= Qold; // No change
    else if (~j & k) Q <= 1'b0; // Reset
    else if (j & ~k) Q <= 1'b1; // Set
    else Q <= ~Qold; // Toggle
end

endmodule