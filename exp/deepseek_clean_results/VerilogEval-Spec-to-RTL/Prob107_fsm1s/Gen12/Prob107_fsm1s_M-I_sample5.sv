module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Use localparam for module-specific constants
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg state = STATE_B;  // Initialize to reset state

    // State transition logic (sequential)
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            // Compact state transition logic
            state <= (state == STATE_B) ? ~in : in;
        end
    end

    // Registered output for better timing and power
    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b1;  // Reset value matches STATE_B output
        end else begin
            out <= (state == STATE_B);
        end
    end

endmodule