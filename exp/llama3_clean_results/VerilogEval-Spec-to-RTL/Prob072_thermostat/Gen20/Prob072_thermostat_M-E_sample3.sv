module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    reg [1:0] state; // 2-bit state register for 4 states
    localparam IDLE = 2'b00, HEATING = 2'b01, COOLING = 2'b10, FANONLY = 2'b11;

    always @(*) begin
        case(state)
            IDLE: begin
                if (mode && too_cold) state = HEATING;
                else if (~mode && too_hot) state = COOLING;
                else if (fan_on) state = FANONLY;
            end
            HEATING: begin
                if (!mode ||!too_cold) state = IDLE;
                else if (fan_on) state = HEATING; // Already in heating mode
            end
            COOLING: begin
                if (mode ||!too_hot) state = IDLE;
                else if (fan_on) state = COOLING; // Already in cooling mode
            end
            FANONLY: begin
                if (mode && too_cold) state = HEATING;
                else if (~mode && too_hot) state = COOLING;
                else if (!fan_on) state = IDLE;
            end
            default: state = IDLE;
        endcase
    end

    always @(*) begin
        case(state)
            IDLE: begin
                heater = 0;
                aircon = 0;
                fan = 0;
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
            FANONLY: begin
                heater = 0;
                aircon = 0;
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