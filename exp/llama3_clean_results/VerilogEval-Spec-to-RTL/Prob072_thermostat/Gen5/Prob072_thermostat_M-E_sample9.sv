module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    enum logic [1:0] {
        IDLE,
        HEATING,
        COOLING,
        FAN_ONLY
    } state, next_state;

    always_comb begin
        case (state)
            IDLE: begin
                if (mode == 1'b1 && too_cold == 1'b1) next_state = HEATING;
                else if (mode == 1'b0 && too_hot == 1'b1) next_state = COOLING;
                else if (fan_on == 1'b1) next_state = FAN_ONLY;
                else next_state = IDLE;
            end
            HEATING: begin
                if (mode == 1'b0 || too_cold == 1'b0) next_state = IDLE;
                else next_state = HEATING;
            end
            COOLING: begin
                if (mode == 1'b1 || too_hot == 1'b0) next_state = IDLE;
                else next_state = COOLING;
            end
            FAN_ONLY: begin
                if (fan_on == 1'b0) next_state = IDLE;
                else next_state = FAN_ONLY;
            end
            default: next_state = IDLE;
        endcase
    end

    always_ff @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        state <= next_state;
    end

    always_comb begin
        case (state)
            IDLE: begin
                heater = 1'b0;
                aircon = 1'b0;
                fan = 1'b0;
            end
            HEATING: begin
                heater = 1'b1;
                aircon = 1'b0;
                fan = 1'b1;
            end
            COOLING: begin
                heater = 1'b0;
                aircon = 1'b1;
                fan = 1'b1;
            end
            FAN_ONLY: begin
                heater = 1'b0;
                aircon = 1'b0;
                fan = 1'b1;
            end
            default: begin
                heater = 1'b0;
                aircon = 1'b0;
                fan = 1'b0;
            end
        endcase
    end

endmodule