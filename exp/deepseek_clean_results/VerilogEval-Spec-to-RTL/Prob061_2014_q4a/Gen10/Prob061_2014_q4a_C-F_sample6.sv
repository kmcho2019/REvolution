module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Priority: Load (L) has highest priority, then Shift (E), else maintain state
// Optimized for PPA: single always block minimizes logic levels and area
always @(posedge clk) begin
    if (L)      Q <= R;    // Synchronous load when L is high
    else if (E) Q <= w;    // Shift when E is high (and L is low)
    // else Q maintains value - most power-efficient case
end

endmodule