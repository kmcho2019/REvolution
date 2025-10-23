module TopModule (
    input clk,    // Clock input (positive edge triggered)
    input w,      // Shift input from previous stage
    input R,      // Parallel load value
    input E,      // Shift enable
    input L,      // Load enable (has priority over shift)
    output reg Q  // Current stage output
);

// Sequential logic with priority: Load > Shift > Hold
always @(posedge clk) begin
    case ({L, E})
        2'b1x: Q <= R;  // Parallel load (highest priority)
        2'b01: Q <= w;  // Shift operation
        default: Q <= Q; // Explicit hold state (optional for clarity)
    endcase
end

endmodule