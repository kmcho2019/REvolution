module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    enum logic [1:0] {IDLE, HEAT, COOL} state, next_state;

    always_ff @(posedge mode) begin
        state <= next_state;
    end

    always_comb begin
        case(state)
            IDLE: begin
                if (mode) next_state = HEAT;
                else if (~mode) next_state = COOL;
                else next_state = IDLE;
                heater = 0;
                aircon = 0;
                fan = fan_on;
            end
            HEAT: begin
                if (too_cold) next_state = HEAT;
                else next_state = IDLE;
                heater = too_cold;
                aircon = 0;
                fan = too_cold || fan_on;
            end
            COOL: begin
                if (too_hot) next_state = COOL;
                else next_state = IDLE;
                heater = 0;
                aircon = too_hot;
                fan = too_hot || fan_on;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule