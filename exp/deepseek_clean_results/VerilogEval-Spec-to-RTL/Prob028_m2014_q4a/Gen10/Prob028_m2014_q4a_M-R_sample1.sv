module TopModule (
    input d,     // Data input
    input ena,   // Enable input (active high)
    output reg q // Latched output (now declared as reg)
);

// D latch implementation using always_latch
// More explicit than continuous assignment
always_latch begin
    if (ena) begin
        q <= d;  // Transparent when enabled
    end
    // Implicit else: retains value when not enabled
end

endmodule