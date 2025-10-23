module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    // Define states
    typedef enum logic {IDLE, ALERT} state_t;
    state_t current_state, next_state;

    // State transition logic
    always_comb begin
        case (current_state)
            IDLE: next_state = ring ? ALERT : IDLE;
            ALERT: next_state = ring ? ALERT : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always_comb begin
        ringer = 0;
        motor = 0;
        
        if (current_state == ALERT) begin
            if (vibrate_mode)
                motor = 1;
            else
                ringer = 1;
        end
    end

    // State register
    always_ff @(posedge ring) begin
        current_state <= next_state;
    end

endmodule