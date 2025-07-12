module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Synthesis optimization attributes
// synthesis attribute async_reg of Q is "true";  // Better metastability protection
// synthesis attribute shreg_extract of Q is "no";  // Prevent unwanted shift register optimization

/* Johnson Counter Operation:
 * - Reset: Synchronous clear (active-low)
 * - Normal operation: Right shift with inverted LSB as new MSB
 * - Complete cycle: 128 states (2N for N=64 bits)
 * Power Optimization:
 * - Clock gating recommended when Q is all 1s or all 0s
 * - Consider adding enable signal to freeze counter when not needed
 */
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Synchronous reset
    end else begin
        // Efficient Johnson counter operation
        // Right shift with MSB = ~LSB
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule