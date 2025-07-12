module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding - binary since we only have 2 states
    parameter STATE_OFF = 1'b0;  // Output = 0
    parameter STATE_ON  = 1'b1;  // Output = 1

    reg current_state;

    // State transition logic - synchronous with active-high reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_OFF;  // Reset to OFF state
        end else begin
            case (current_state)
                STATE_OFF: 
                    current_state <= j ? STATE_ON : STATE_OFF;  // J=1: transition to ON
                STATE_ON: 
                    current_state <= k ? STATE_OFF : STATE_ON;   // K=1: transition to OFF
            endcase
        end
    end

    // Moore output - directly derived from current state
    assign out = (current_state == STATE_ON);

endmodule