module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    reg [1:0] state;

    always @(*) begin
        case (state)
            2'b00: begin // idle
                if (mode && too_cold) begin
                    state = 2'b01; // heating
                end else if (~mode && too_hot) begin
                    state = 2'b10; // cooling
                end else if (fan_on) begin
                    state = 2'b11; // fan_only
                end
            end
            2'b01: begin // heating
                if (~mode || ~too_cold) begin
                    state = 2'b00; // idle
                end
            end
            2'b10: begin // cooling
                if (mode || ~too_hot) begin
                    state = 2'b00; // idle
                end
            end
            2'b11: begin // fan_only
                if (~fan_on) begin
                    state = 2'b00; // idle
                end
            end
        endcase
    end

    always @(*) begin
        case (state)
            2'b00: begin // idle
                heater = 0;
                aircon = 0;
                fan = 0;
            end
            2'b01: begin // heating
                heater = 1;
                aircon = 0;
                fan = 1;
            end
            2'b10: begin // cooling
                heater = 0;
                aircon = 1;
                fan = 1;
            end
            2'b11: begin // fan_only
                heater = 0;
                aircon = 0;
                fan = 1;
            end
        endcase
    end

endmodule