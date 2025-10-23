module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Define states
    typedef enum logic [1:0] {
        IDLE,
        HEATING,
        COOLING,
        FAN_ONLY
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_comb begin
        case (current_state)
            IDLE: begin
                if (fan_on) next_state = FAN_ONLY;
                else if (mode & too_cold) next_state = HEATING;
                else if (~mode & too_hot) next_state = COOLING;
                else next_state = IDLE;
            end
            HEATING: begin
                if (fan_on) next_state = HEATING; // Maintain heating priority
                else if (~mode | ~too_cold) next_state = IDLE;
                else next_state = HEATING;
            end
            COOLING: begin
                if (fan_on) next_state = COOLING; // Maintain cooling priority
                else if (mode | ~too_hot) next_state = IDLE;
                else next_state = COOLING;
            end
            FAN_ONLY: begin
                if (~fan_on) next_state = IDLE;
                else if (mode & too_cold) next_state = HEATING;
                else if (~mode & too_hot) next_state = COOLING;
                else next_state = FAN_ONLY;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always_comb begin
        heater = (current_state == HEATING);
        aircon = (current_state == COOLING);
        fan = (current_state != IDLE);
    end

    // State register
    always @(*) begin
        current_state = next_state;
    end

endmodule