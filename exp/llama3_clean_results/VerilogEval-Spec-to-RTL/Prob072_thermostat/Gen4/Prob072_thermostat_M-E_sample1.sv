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
    parameter Idle = 2'b00;
    parameter Heating = 2'b01;
    parameter Cooling = 2'b10;
    parameter FanOnly = 2'b11;

    always @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        case (state)
            Idle: begin
                if (mode && too_cold) state <= Heating;
                else if (~mode && too_hot) state <= Cooling;
                else if (fan_on) state <= FanOnly;
            end
            Heating: begin
                if (~mode || ~too_cold) state <= Idle;
            end
            Cooling: begin
                if (mode || ~too_hot) state <= Idle;
            end
            FanOnly: begin
                if (~fan_on) state <= Idle;
            end
        endcase
    end

    always @(state) begin
        case (state)
            Idle: begin
                heater <= 0;
                aircon <= 0;
                fan <= 0;
            end
            Heating: begin
                heater <= 1;
                aircon <= 0;
                fan <= 1;
            end
            Cooling: begin
                heater <= 0;
                aircon <= 1;
                fan <= 1;
            end
            FanOnly: begin
                heater <= 0;
                aircon <= 0;
                fan <= 1;
            end
        endcase
    end

endmodule