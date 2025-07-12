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
                if (mode && too_cold) next_state = HEATING;
                else if (!mode && too_hot) next_state = COOLING;
                else if (fan_on) next_state = FAN_ONLY;
                else next_state = IDLE;
            end
            HEATING: begin
                if (!mode || !too_cold) begin
                    if (fan_on) next_state = FAN_ONLY;
                    else next_state = IDLE;
                end
                else next_state = HEATING;
            end
            COOLING: begin
                if (mode || !too_hot) begin
                    if (fan_on) next_state = FAN_ONLY;
                    else next_state = IDLE;
                end
                else next_state = COOLING;
            end
            FAN_ONLY: begin
                if (!fan_on) begin
                    if (mode && too_cold) next_state = HEATING;
                    else if (!mode && too_hot) next_state = COOLING;
                    else next_state = IDLE;
                end
                else next_state = FAN_ONLY;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always_comb begin
        heater = 0;
        aircon = 0;
        fan = 0;
        
        case (current_state)
            HEATING: begin
                heater = 1;
                fan = 1;
            end
            COOLING: begin
                aircon = 1;
                fan = 1;
            end
            FAN_ONLY: begin
                fan = 1;
            end
            default: ; // IDLE state - all outputs remain 0
        endcase
    end

    // State register
    always_ff @(posedge clk) begin
        current_state <= next_state;
    end

endmodule