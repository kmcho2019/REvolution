module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    reg [1:0] state; // 0: idle, 1: heating, 2: cooling

    always @(*) begin
        case (state)
            0: begin // idle
                if (mode && too_cold) begin
                    state = 1; // heating
                    heater = 1;
                    aircon = 0;
                    fan = 1;
                end else if (!mode && too_hot) begin
                    state = 2; // cooling
                    heater = 0;
                    aircon = 1;
                    fan = 1;
                end else if (fan_on) begin
                    state = 0; // idle with fan on
                    heater = 0;
                    aircon = 0;
                    fan = 1;
                end else begin
                    state = 0; // idle
                    heater = 0;
                    aircon = 0;
                    fan = 0;
                end
            end
            1: begin // heating
                if (!mode || !too_cold) begin
                    state = 0; // idle
                    heater = 0;
                    aircon = 0;
                    fan = fan_on;
                end else begin
                    state = 1; // heating
                    heater = 1;
                    aircon = 0;
                    fan = 1;
                end
            end
            2: begin // cooling
                if (mode || !too_hot) begin
                    state = 0; // idle
                    heater = 0;
                    aircon = 0;
                    fan = fan_on;
                end else begin
                    state = 2; // cooling
                    heater = 0;
                    aircon = 1;
                    fan = 1;
                end
            end
        endcase
    end

endmodule