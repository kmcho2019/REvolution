module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Define states
    typedef enum logic [1:0] {
        STATE_BELOW_S0,      // No sensors on
        STATE_BETWEEN_S1_S0, // Only s[0] on
        STATE_BETWEEN_S2_S1, // s[0] and s[1] on
        STATE_ABOVE_S2       // All sensors on
    } state_t;

    state_t current_state, next_state;
    reg [2:0] prev_sensors;
    reg was_decreasing;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW_S0;
            prev_sensors <= 3'b000;
            was_decreasing <= 1'b0;
        end else begin
            prev_sensors <= s;
            current_state <= next_state;
            
            // Detect if previous transition was decreasing (for dfr)
            if ((current_state == STATE_BETWEEN_S1_S0 && next_state == STATE_BELOW_S0) ||
                (current_state == STATE_BETWEEN_S2_S1 && next_state == STATE_BETWEEN_S1_S0) ||
                (current_state == STATE_ABOVE_S2 && next_state == STATE_BETWEEN_S2_S1)) begin
                was_decreasing <= 1'b1;
            end else if ((current_state == STATE_BELOW_S0 && next_state == STATE_BETWEEN_S1_S0) ||
                       (current_state == STATE_BETWEEN_S1_S0 && next_state == STATE_BETWEEN_S2_S1) ||
                       (current_state == STATE_BETWEEN_S2_S1 && next_state == STATE_ABOVE_S2)) begin
                was_decreasing <= 1'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (s)
            3'b000: next_state = STATE_BELOW_S0;
            3'b001: next_state = STATE_BETWEEN_S1_S0;
            3'b011: next_state = STATE_BETWEEN_S2_S1;
            3'b111: next_state = STATE_ABOVE_S2;
            default: next_state = current_state; // Handle invalid states by staying
        endcase
    end

    // Output logic
    assign fr0 = (current_state == STATE_BETWEEN_S2_S1) || 
                 (current_state == STATE_BETWEEN_S1_S0) || 
                 (current_state == STATE_BELOW_S0);
    
    assign fr1 = (current_state == STATE_BETWEEN_S1_S0) || 
                 (current_state == STATE_BELOW_S0);
    
    assign fr2 = (current_state == STATE_BELOW_S0);
    
    // dfr is asserted when transitioning to a higher level (was_decreasing is false)
    assign dfr = ((current_state == STATE_BETWEEN_S1_S0 && prev_sensors == 3'b000) ||
                 (current_state == STATE_BETWEEN_S2_S1 && prev_sensors == 3'b001) ||
                 (current_state == STATE_ABOVE_S2 && prev_sensors == 3'b011)) && 
                 !was_decreasing;

endmodule