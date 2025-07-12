/**
 * Circular Shift Register with Synchronous Reset
 * 
 * Features:
 * - Implements 8-bit register as circular shift register
 * - Positive edge-triggered operation
 * - Synchronous active-high reset (sets all bits to 0)
 * - Compact single always block implementation
 * - Novel architecture with potential power benefits
 */

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b0;  // Synchronous reset clears all bits
        end else begin
            // Circular shift register implementation
            q <= {q[6:0], q[7]};  // Normally circulate bits
            q[0] <= d[0];         // Inject new data at LSB
            q[1] <= d[1];
            q[2] <= d[2];
            q[3] <= d[3];
            q[4] <= d[4];
            q[5] <= d[5];
            q[6] <= d[6];
            q[7] <= d[7];
        end
    end

endmodule