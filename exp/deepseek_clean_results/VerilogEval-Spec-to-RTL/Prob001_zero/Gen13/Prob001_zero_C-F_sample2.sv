/* Constant LOW Output Module
 * Description: Always outputs a logical LOW (0) signal
 * Features: Zero-power, minimal-area, constant propagation
 */
module TopModule (
    output zero    // Ground-level constant output
);
    assign zero = 1'b0;  // Direct ground connection
endmodule