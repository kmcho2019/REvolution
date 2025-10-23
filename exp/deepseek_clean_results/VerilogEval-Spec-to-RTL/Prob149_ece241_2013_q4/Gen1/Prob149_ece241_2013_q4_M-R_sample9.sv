module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // States encoded as binary for easy comparison (lower value = higher water level)
    typedef enum logic [1:0] {
        STATE_ABOVE_S2      = 2'b00,  // All sensors on
        STATE_BETWEEN_S2_S1 = 2'b01,  // s[0] and s[1] on
        STATE_BETWEEN_S1_S0 = 2'b10,  // Only s[0] on
        STATE_BELOW_S0      = 2'b11   // No sensors on
    } state_t;

    state_t current_state, next_state;

    // State register
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_BELOW_S0;
        else
            current_state <= next_state;
    end

    // Next state logic (fully combinatorial)
    always @(*) begin
        case (s)
            3'b111:  next_state = STATE_ABOVE_S2;
            3'b011:  next_state = STATE_BETWEEN_S2_S1;
            3'b001:  next_state = STATE_BETWEEN_S1_S0;
            3'b000:  next_state = STATE_BELOW_S0;
            default: next_state = STATE_BELOW_S0; // Invalid input -> safest state
        endcase
    end

    // Output logic - purely combinatorial
    assign fr0 = (current_state == STATE_BETWEEN_S2_S1) || 
                 (current_state == STATE_BETWEEN_S1_S0) || 
                 (current_state == STATE_BELOW_S0);
    
    assign fr1 = (current_state == STATE_BETWEEN_S1_S0) || 
                 (current_state == STATE_BELOW_S0);
    
    assign fr2 = (current_state == STATE_BELOW_S0);
    
    // dfr asserts when moving to a higher level (numerically lower state)
    assign dfr = (next_state < current_state);

endmodule