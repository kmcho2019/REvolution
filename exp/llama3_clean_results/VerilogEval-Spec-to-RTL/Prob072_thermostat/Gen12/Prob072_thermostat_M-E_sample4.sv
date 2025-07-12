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

    // Combinational logic for next state
    always_comb begin
        case (state)
            IDLE: begin
                if (mode && too_cold) next_state = HEATING;
                else if (~mode && too_hot) next_state = COOLING;
                else if (fan_on) next_state = IDLE; // Stay in IDLE if fan_on but no heating/cooling needed
                else next_state = IDLE;
            end
            HEATING: begin
                if (~mode || !too_cold) next_state = IDLE;
                else next_state = HEATING;
            end
            COOLING: begin
                if (mode || !too_hot) next_state = IDLE;
                else next_state = COOLING;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state register
    always_ff @(posedge clk) begin
        state <= next_state;
    end

    // Output logic based on state
    always_comb begin
        case (state)
            IDLE: begin
                heater = 0;
                aircon = 0;
                fan = fan_on;
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
            default: begin
                heater = 0;
                aircon = 0;
                fan = 0;
            end
        endcase
    end

endmodule