// Refactored solution
module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

always @(posedge clk) begin
    case ({L, E})
        2'b11: Q <= R; // If L and E are both high, load R into Q
        2'b01: Q <= w; // If only E is high, shift w into Q
        default: Q <= Q; // Otherwise, keep Q unchanged
    endcase
end

endmodule