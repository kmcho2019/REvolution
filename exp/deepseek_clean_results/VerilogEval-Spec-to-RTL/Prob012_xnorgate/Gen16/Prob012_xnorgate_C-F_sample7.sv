module TopModule (
    input a,
    input b,
    output out
);
    // Optimal fused implementation:
    // Clear XNOR functionality using direct equality comparison
    // Compact ternary operator form
    // No intermediate signals for better power/area
    assign out = (a == b) ? 1'b1 : 1'b0;
endmodule