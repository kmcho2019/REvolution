module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Define the states for the FSM
    enum logic [1:0] {IDLE, HEAT_ON, COOL_ON, FAN_ON} state;

    // Initialize the state to IDLE
    initial state = IDLE;

    // Always block for state transitions
    always @(*) begin
        case (state)
            IDLE: begin
                if (mode && too_cold) state = HEAT_ON;
                else if (~mode && too_hot) state = COOL_ON;
                else if (fan_on) state = FAN_ON;
            end
            HEAT_ON: begin
                if (~too_cold) state = IDLE;
            end
            COOL_ON: begin
                if (~too_hot) state = IDLE;
            end
            FAN_ON: begin
                if (~fan_on) state = IDLE;
            end
        endcase
    end

    // Combinational logic for output generation
    always @(*) begin
        case (state)
            IDLE: begin
                heater = 0;
                aircon = 0;
                fan = 0;
            end
            HEAT_ON: begin
                heater = 1;
                aircon = 0;
                fan = 1;
            end
            COOL_ON: begin
                heater = 0;
                aircon = 1;
                fan = 1;
            end
            FAN_ON: begin
                heater = 0;
                aircon = 0;
                fan = 1;
            end
        endcase
    end

endmodule