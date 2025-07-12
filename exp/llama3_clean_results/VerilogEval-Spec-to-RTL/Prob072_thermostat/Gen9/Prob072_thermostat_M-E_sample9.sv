module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Define states
    enum logic [1:0] {IDLE, HEATING, COOLING} state, next_state;

    // Initialize state
    initial state = IDLE;

    // Next state logic
    always_comb begin
        case(state)
            IDLE: next_state = mode ? HEATING : COOLING;
            HEATING: next_state = mode ? HEATING : COOLING;
            COOLING: next_state = mode ? HEATING : COOLING;
            default: next_state = IDLE;
        endcase
    end

    // Output logic based on state and inputs
    always_comb begin
        case(state)
            HEATING: begin
                heater = too_cold;
                aircon = 1'b0;
                fan = too_cold || fan_on;
            end
            COOLING: begin
                heater = 1'b0;
                aircon = too_hot;
                fan = too_hot || fan_on;
            end
            default: begin
                heater = 1'b0;
                aircon = 1'b0;
                fan = fan_on;
            end
        endcase
    end

    // State register
    always_ff @(posedge mode) begin
        state <= next_state;
    end

endmodule