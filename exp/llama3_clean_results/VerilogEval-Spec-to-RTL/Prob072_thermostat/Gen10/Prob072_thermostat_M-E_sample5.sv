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
    reg heater_reg, aircon_reg, fan_reg;

    always @(*) begin
        case (state)
            2'b00: begin // Idle state
                if (mode && too_cold) begin
                    state = 2'b01; // Transition to Heating state
                end else if (~mode && too_hot) begin
                    state = 2'b10; // Transition to Cooling state
                end else if (fan_on) begin
                    state = 2'b11; // Transition to FanOnly state
                end
            end
            2'b01: begin // Heating state
                if (~mode || ~too_cold) begin
                    state = 2'b00; // Transition back to Idle state
                end
            end
            2'b10: begin // Cooling state
                if (mode || ~too_hot) begin
                    state = 2'b00; // Transition back to Idle state
                end
            end
            2'b11: begin // FanOnly state
                if (~fan_on) begin
                    state = 2'b00; // Transition back to Idle state
                end
            end
        endcase
    end

    always @(*) begin
        case (state)
            2'b00: begin // Idle state
                heater_reg = 1'b0;
                aircon_reg = 1'b0;
                fan_reg = 1'b0;
            end
            2'b01: begin // Heating state
                heater_reg = 1'b1;
                aircon_reg = 1'b0;
                fan_reg = 1'b1;
            end
            2'b10: begin // Cooling state
                heater_reg = 1'b0;
                aircon_reg = 1'b1;
                fan_reg = 1'b1;
            end
            2'b11: begin // FanOnly state
                heater_reg = 1'b0;
                aircon_reg = 1'b0;
                fan_reg = 1'b1;
            end
        endcase
    end

    assign heater = heater_reg;
    assign aircon = aircon_reg;
    assign fan = fan_reg;

    initial begin
        state = 2'b00; // Initialize to Idle state
    end

endmodule