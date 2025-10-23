module TopModule (
    input clk,      // Clock input
    input w,        // Shift input from previous stage
    input R,        // Parallel load value
    input E,        // Shift enable (active high)
    input L,        // Load enable (active high, has priority)
    output reg Q    // Register output
);

// Sequential logic with clear priority:
// 1. Load (L) has highest priority
// 2. Shift (E) comes next
// 3. Otherwise maintain current value
always @(posedge clk) begin
    if (L)
        Q <= R;     // Parallel load
    else if (E)
        Q <= w;     // Shift operation
    // else implicit: Q <= Q (hold current value)
end

endmodule