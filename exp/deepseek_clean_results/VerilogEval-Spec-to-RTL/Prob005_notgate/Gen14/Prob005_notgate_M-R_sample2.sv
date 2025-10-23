/*
 * Design Considerations:
 * 1. Performance: Direct mapping to inverter cell (~1 gate delay)
 * 2. Power: Consider high-Vt cells if timing allows
 * 3. Area: Minimal (1 standard cell)
 * 4. Robustness: Explicit handling of all input cases (0,1,x,z)
 * 
 * Optimization Paths:
 * - Technology: Use smallest available standard cell
 * - Layout: Co-locate with fanout logic
 * - System: Consider logic merging in larger designs
 */

module TopModule (
    input in,
    output reg out
);
    always @(*) begin
        case (in)
            1'b0: out = 1'b1;
            1'b1: out = 1'b0;
            default: out = 1'bx; // Handle x/z cases
        endcase
    end
endmodule