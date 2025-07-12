module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// synthesis attributes for optimal implementation
// synthesis attribute async_reg of Q is "true";  // Improves timing closure
// synthesis attribute shreg_extract of Q is "no";  // Prevents unwanted optimization

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low synchronous reset (all zeros)
    end else begin
        /* Johnson Counter Operation:
         * Complete cycle: 128 states (2N for N=64 bits)
         * State transitions:
         *   When Q[0]==0: Right shift and insert 1 at MSB (counting up)
         *   When Q[0]==1: Right shift and insert 0 at MSB (counting down)
         * Power Optimization:
         *   - Clock gating recommended when Q is all 0s or all 1s
         * Timing Optimization:
         *   - For critical paths, consider 2-stage pipelined shift (32-bit each)
         * Area Optimization:
         *   - Evaluate SRL-based implementation if targeting FPGAs
         */
        Q <= {~Q[0], Q[63:1]};  // Efficient single-cycle shift operation
    end
end

endmodule