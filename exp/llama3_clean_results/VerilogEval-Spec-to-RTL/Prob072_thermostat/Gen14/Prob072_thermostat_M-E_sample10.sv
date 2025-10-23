module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Define the states of the FSM
    enum logic [1:0] {Idle, Heating, Cooling, FanOnly} state, nextState;

    // Initialize the state
    initial state = Idle;

    // FSM logic
    always_comb begin
        case (state)
            Idle: begin
                if (mode && too_cold) nextState = Heating;
                else if (~mode && too_hot) nextState = Cooling;
                else if (fan_on) nextState = FanOnly;
                else nextState = Idle;
            end
            Heating: begin
                if (~mode || ~too_cold) nextState = Idle;
                else if (fan_on) nextState = Heating; // Stay in Heating if fan_on
                else nextState = Heating;
            end
            Cooling: begin
                if (mode || ~too_hot) nextState = Idle;
                else if (fan_on) nextState = Cooling; // Stay in Cooling if fan_on
                else nextState = Cooling;
            end
            FanOnly: begin
                if (~fan_on) nextState = Idle;
                else nextState = FanOnly;
            end
            default: nextState = Idle;
        endcase
    end

    // Update the state
    always_ff @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        state <= nextState;
    end

    // Output logic
    always_comb begin
        case (state)
            Idle: begin
                heater = 0;
                aircon = 0;
                fan = 0;
            end
            Heating: begin
                heater = 1;
                aircon = 0;
                fan = 1;
            end
            Cooling: begin
                heater = 0;
                aircon = 1;
                fan = 1;
            end
            FanOnly: begin
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