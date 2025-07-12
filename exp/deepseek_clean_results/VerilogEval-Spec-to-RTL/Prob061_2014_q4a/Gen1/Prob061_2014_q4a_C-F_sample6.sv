module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// Priority: Load (L) > Shift (E) > Maintain state
always @(posedge clk) begin
    case ({L, E})
        2'b1x: Q <= R;    // Load has highest priority
        2'b01: Q <= w;    // Shift when enabled and not loading
        default: Q <= Q;  // Explicit state maintenance (optional but clear)
    endcase
end

endmodule