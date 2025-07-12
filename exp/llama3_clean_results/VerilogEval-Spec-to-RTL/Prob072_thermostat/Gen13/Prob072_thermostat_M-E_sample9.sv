module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    reg [1:0] state;
    parameter HEATING = 2'b00, COOLING = 2'b01, IDLE = 2'b10;

    always @(mode, too_cold, too_hot, fan_on) begin
        case (state)
            HEATING: begin
                if (~mode) begin
                    state <= COOLING;
                end else if (~too_cold) begin
                    state <= IDLE;
                end
            end
            COOLING: begin
                if (mode) begin
                    state <= HEATING;
                end else if (~too_hot) begin
                    state <= IDLE;
                end
            end
            IDLE: begin
                if (mode && too_cold) begin
                    state <= HEATING;
                end else if (~mode && too_hot) begin
                    state <= COOLING;
                end
            end
            default: state <= IDLE;
        endcase
    end

    always @(state, fan_on) begin
        case (state)
            HEATING: begin
                heater <= 1'b1;
                aircon <= 1'b0;
                fan <= fan_on || 1'b1;
            end
            COOLING: begin
                heater <= 1'b0;
                aircon <= 1'b1;
                fan <= fan_on || 1'b1;
            end
            IDLE: begin
                heater <= 1'b0;
                aircon <= 1'b0;
                fan <= fan_on;
            end
            default: begin
                heater <= 1'b0;
                aircon <= 1'b0;
                fan <= fan_on;
            end
        endcase
    end

endmodule