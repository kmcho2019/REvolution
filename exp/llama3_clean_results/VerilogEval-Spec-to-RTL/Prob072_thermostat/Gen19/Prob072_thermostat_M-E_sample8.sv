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
    enum logic [1:0] {Idle, Heating, Cooling, FanOnly} state, next_state;

    // Initialize the state
    initial state = Idle;

    // FSM transition logic
    always_comb begin
        case (state)
            Idle: begin
                if (mode && too_cold) next_state = Heating;
                else if (~mode && too_hot) next_state = Cooling;
                else if (fan_on) next_state = FanOnly;
                else next_state = Idle;
            end
            Heating: begin
                if (~mode || ~too_cold) next_state = Idle;
                else next_state = Heating;
            end
            Cooling: begin
                if (mode || ~too_hot) next_state = Idle;
                else next_state = Cooling;
            end
            FanOnly: begin
                if (~fan_on) next_state = Idle;
                else next_state = FanOnly;
            end
            default: next_state = Idle;
        endcase
    end

    // Update the state
    always_ff @(posedge mode) begin
        state <= next_state;
    end

    // Output logic based on the current state
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