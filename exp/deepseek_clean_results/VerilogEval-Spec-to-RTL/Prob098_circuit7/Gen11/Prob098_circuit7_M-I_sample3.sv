module TopModule (
    input clk,    // System clock
    input a,      // Input signal
    output reg q   // Registered output
);

reg prev_a;  // Stores previous value of a

// Synchronous logic with change detection
always @(posedge clk) begin
    if (a != prev_a) begin  // Only update when a changes
        q <= ~a;
    end
    prev_a <= a;  // Store current a value
end

// Initialize outputs (simulation only)
initial begin
    q = 1'b0;
    prev_a = 1'b0;
end

endmodule