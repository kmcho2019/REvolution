module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    enum logic [1:0] {OFF, HEATING, COOLING} state, nextState;

    always_comb begin
        case (state)
            OFF: begin
                if (mode && too_cold) begin
                    nextState = HEATING;
                end else if (~mode && too_hot) begin
                    nextState = COOLING;
                end else if (fan_on) begin
                    nextState = OFF; // Fan can be on in OFF state if requested
                end else begin
                    nextState = OFF;
                end
            end
            HEATING: begin
                if (~mode || ~too_cold) begin
                    nextState = OFF;
                end else begin
                    nextState = HEATING;
                end
            end
            COOLING: begin
                if (mode || ~too_hot) begin
                    nextState = OFF;
                end else begin
                    nextState = COOLING;
                end
            end
            default: nextState = OFF;
        endcase
    end

    always_ff @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        state <= nextState;
    end

    always_comb begin
        case (state)
            OFF: begin
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