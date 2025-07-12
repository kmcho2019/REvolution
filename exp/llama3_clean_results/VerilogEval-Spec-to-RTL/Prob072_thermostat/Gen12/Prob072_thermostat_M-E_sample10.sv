module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Enumerate the states of the FSM
    enum logic [1:0] {
        IDLE,
        HEATING,
        COOLING,
        FAN_ONLY
    } state, next_state;

    // Initialize the current state to IDLE
    initial state = IDLE;

    // Combinational logic for next state
    always_comb begin
        case (state)
            IDLE: begin
                if (mode && too_cold) begin
                    next_state = HEATING;
                end else if (~mode && too_hot) begin
                    next_state = COOLING;
                end else if (fan_on) begin
                    next_state = FAN_ONLY;
                end else begin
                    next_state = IDLE;
                end
            end
            HEATING: begin
                if (~mode || ~too_cold) begin
                    next_state = IDLE;
                end else begin
                    next_state = HEATING;
                end
            end
            COOLING: begin
                if (mode || ~too_hot) begin
                    next_state = IDLE;
                end else begin
                    next_state = COOLING;
                end
            end
            FAN_ONLY: begin
                if (~fan_on) begin
                    next_state = IDLE;
                end else begin
                    next_state = FAN_ONLY;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic to update the state
    always_ff @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        state <= next_state;
    end

    // Output logic based on the current state
    always_comb begin
        case (state)
            IDLE: begin
                heater = 0;
                aircon = 0;
                fan = 0;
            end
            HEATING: begin
                heater = 1;
                aircon = 0;
                fan = 1;
            end
            COOLING: begin
                heater = 0;
                aircon = 1;
                fan = 1;
            end
            FAN_ONLY: begin
                heater = 0;
                aircon = 0;
                fan = 1;
            end
            default: begin
                heater = 0;
                aircon = 0;
                fan = 0;
            end
        endcase
    end

endmodule