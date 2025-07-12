module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

    // Define states - encoded such that higher values = higher water levels
    typedef enum logic [1:0] {
        STATE_BELOW_S0      = 2'b00,  // No sensors
        STATE_BETWEEN_S1_S0 = 2'b01,  // s[0]
        STATE_BETWEEN_S2_S1 = 2'b10,  // s[0],s[1]
        STATE_ABOVE_S2      = 2'b11   // s[0],s[1],s[2]
    } state_t;

    state_t current_state, next_state;
    state_t prev_state;

    // State transition logic
    always_comb begin
        casez (s)
            3'b??1: next_state = STATE_BETWEEN_S1_S0;
            3'b?11: next_state = STATE_BETWEEN_S2_S1;
            3'b111: next_state = STATE_ABOVE_S2;
            default: next_state = STATE_BELOW_S0;
        endcase
    end

    // State register and previous state tracking
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_BELOW_S0;
            prev_state <= STATE_BELOW_S0;
        end else begin
            prev_state <= current_state;
            current_state <= next_state;
        end
    end

    // Output logic - combinational with reset override
    assign fr0 = reset ? 1'b1 : (current_state != STATE_ABOVE_S2);
    assign fr1 = reset ? 1'b1 : (current_state == STATE_BETWEEN_S1_S0 || 
                                current_state == STATE_BELOW_S0);
    assign fr2 = reset ? 1'b1 : (current_state == STATE_BELOW_S0);
    assign dfr = reset ? 1'b1 : (current_state > prev_state);  // Rising level transition

endmodule