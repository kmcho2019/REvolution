module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Define the states of the finite state machine
    enum logic [1:0] {Idle, Heating, Cooling, FanOnly} state, next_state;

    // Initialize the current state to Idle
    initial state = Idle;

    // FSM logic
    always_comb begin
        // Default next state is the current state
        next_state = state;

        case (state)
            Idle: begin
                if (mode == 1'b1 && too_cold == 1'b1) next_state = Heating;
                else if (mode == 1'b0 && too_hot == 1'b1) next_state = Cooling;
                else if (fan_on == 1'b1) next_state = FanOnly;
            end
            Heating: begin
                if (mode == 1'b0 || too_cold == 1'b0) next_state = Idle;
            end
            Cooling: begin
                if (mode == 1'b1 || too_hot == 1'b0) next_state = Idle;
            end
            FanOnly: begin
                if (fan_on == 1'b0) next_state = Idle;
            end
        endcase
    end

    // Update the current state
    always_ff @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        state <= next_state;
    end

    // Output logic
    always_comb begin
        heater = (state == Heating);
        aircon = (state == Cooling);
        fan = (state == Heating || state == Cooling || state == FanOnly);
    end

endmodule