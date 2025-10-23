module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    enum logic [1:0] {IDLE, HEATING, COOLING} state, next_state;

    always_comb begin
        case (state)
            IDLE: begin
                if (mode) next_state = HEATING;
                else next_state = COOLING;
            end
            HEATING: begin
                if (too_cold) begin
                    heater = 1'b1;
                    fan = 1'b1;
                end else begin
                    heater = 1'b0;
                    fan = fan_on;
                end
                if (~mode) next_state = COOLING;
                else next_state = HEATING;
            end
            COOLING: begin
                if (too_hot) begin
                    aircon = 1'b1;
                    fan = 1'b1;
                end else begin
                    aircon = 1'b0;
                    fan = fan_on;
                end
                if (mode) next_state = HEATING;
                else next_state = COOLING;
            end
        endcase
    end

    always_ff @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        state <= next_state;
        if (state == HEATING) begin
            aircon <= 1'b0;
        end else if (state == COOLING) begin
            heater <= 1'b0;
        end
    end

endmodule