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
        2'b00: // Idle
            begin
                heater = 0;
                aircon = 0;
                fan = 0;
                if (mode && too_cold) begin
                    state = 2'b01; // Heating
                end else if (~mode && too_hot) begin
                    state = 2'b10; // Cooling
                end else if (fan_on) begin
                    state = 2'b11; // FanOn
                end
            end
        2'b01: // Heating
            begin
                heater = 1;
                aircon = 0;
                fan = 1;
                if (!(mode && too_cold)) begin
                    state = 2'b00; // Idle
                end
            end
        2'b10: // Cooling
            begin
                heater = 0;
                aircon = 1;
                fan = 1;
                if (!(~mode && too_hot)) begin
                    state = 2'b00; // Idle
                end
            end
        2'b11: // FanOn
            begin
                heater = 0;
                aircon = 0;
                fan = 1;
                if (!fan_on) begin
                    state = 2'b00; // Idle
                end
            end
    endcase
end

initial begin
    state = 2'b00; // Initialize to Idle state
end

endmodule