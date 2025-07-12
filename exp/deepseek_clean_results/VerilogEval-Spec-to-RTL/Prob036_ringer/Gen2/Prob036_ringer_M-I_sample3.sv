module TopModule (
    input  wire ring,         // Active-high signal indicating incoming call
    input  wire vibrate_mode, // Active-high signal for vibration mode selection
    output reg  ringer,       // Active-high control for ringer circuit
    output reg  motor         // Active-high control for vibration motor
);

    // Combinational logic for output control
    always @(*) begin
        // Default outputs (both off when no call)
        ringer = 1'b0;
        motor  = 1'b0;
        
        // Only activate outputs when there's an incoming call
        if (ring) begin
            // Exclusive activation based on vibrate mode
            if (vibrate_mode) begin
                motor = 1'b1;  // Vibrate mode active
            end else begin
                ringer = 1'b1; // Normal ring mode
            end
        end
    end

    /* Design Constraints:
     * - Outputs are mutually exclusive by design
     * - Only active when ring input is high
     * - Minimal gate count implementation (equivalent to original)
     * - Clear priority: vibrate_mode overrides normal ring
     */
endmodule