module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    reg [1:0] state; // 0: COOLING, 1: HEATING

    always @(*) begin
        case(state)
            0'b0: // COOLING
                begin
                    heater = 0;
                    aircon = too_hot;
                    fan = aircon || fan_on;
                end
            0'b1: // HEATING
                begin
                    heater = too_cold;
                    aircon = 0;
                    fan = heater || fan_on;
                end
            default:
                begin
                    heater = 0;
                    aircon = 0;
                    fan = 0;
                end
        endcase
    end

    always @(mode) begin
        if (mode)
            state = 0'b1; // Set to HEATING mode
        else
            state = 0'b0; // Set to COOLING mode
    end

endmodule