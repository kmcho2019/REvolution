module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Enumerate the states of the FSM
    enum logic [1:0] {IDLE, HEATING, COOLING} state, next_state;

    // Initialize the outputs
    initial begin
        heater = 0;
        aircon = 0;
        fan = 0;
    end

    // FSM combinational logic
    always_comb begin
        // Default values for outputs in the current state
        heater = 0;
        aircon = 0;
        fan = 0;

        case (state)
            IDLE: begin
                // If mode is set to heating and it's too cold, transition to HEATING
                if (mode && too_cold) next_state = HEATING;
                // If mode is set to cooling and it's too hot, transition to COOLING
                else if (~mode && too_hot) next_state = COOLING;
                // If fan_on is asserted, turn on the fan regardless of mode
                if (fan_on) fan = 1;
                else next_state = IDLE;
            end
            HEATING: begin
                // Turn on the heater if it's too cold
                if (too_cold) heater = 1;
                // Turn on the fan if the heater is on or if fan_on is asserted
                if (heater || fan_on) fan = 1;
                // Transition back to IDLE if it's no longer too cold
                if (~too_cold) next_state = IDLE;
                else next_state = HEATING;
            end
            COOLING: begin
                // Turn on the air conditioner if it's too hot
                if (too_hot) aircon = 1;
                // Turn on the fan if the air conditioner is on or if fan_on is asserted
                if (aircon || fan_on) fan = 1;
                // Transition back to IDLE if it's no longer too hot
                if (~too_hot) next_state = IDLE;
                else next_state = COOLING;
            end
            default: next_state = IDLE;
        endcase
    end

    // FSM sequential logic
    always_ff @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        state <= next_state;
    end

endmodule