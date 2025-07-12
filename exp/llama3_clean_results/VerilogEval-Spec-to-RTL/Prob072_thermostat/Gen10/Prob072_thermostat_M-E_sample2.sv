module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Define the states of the FSM
    enum logic [1:0] {IDLE, HEATING, COOLING, FAN_ONLY} state, next_state;

    // Initialize the state to IDLE
    initial state = IDLE;

    // Combinational logic for the next state
    always @(*) begin
        case (state)
            IDLE: begin
                if (mode && too_cold) next_state = HEATING;
                else if (!mode && too_hot) next_state = COOLING;
                else if (fan_on) next_state = FAN_ONLY;
                else next_state = IDLE;
            end
            HEATING: begin
                if (!mode || !too_cold) next_state = IDLE;
                else next_state = HEATING;
            end
            COOLING: begin
                if (mode || !too_hot) next_state = IDLE;
                else next_state = COOLING;
            end
            FAN_ONLY: begin
                if (!fan_on) next_state = IDLE;
                else next_state = FAN_ONLY;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for the state update
    always @(posedge mode, posedge too_cold, posedge too_hot, posedge fan_on) begin
        state = next_state;
    end

    // Output logic based on the current state
    always @(*) begin
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