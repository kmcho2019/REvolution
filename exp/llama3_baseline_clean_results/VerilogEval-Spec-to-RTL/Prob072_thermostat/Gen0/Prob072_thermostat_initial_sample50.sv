module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    always @(mode, too_cold, too_hot, fan_on) begin
        case (mode)
            1'b1: begin // heating mode
                heater = too_cold;
                aircon = 1'b0;
                fan = (too_cold || fan_on);
            end
            1'b0: begin // cooling mode
                heater = 1'b0;
                aircon = too_hot;
                fan = (too_hot || fan_on);
            end
            default: begin
                heater = 1'b0;
                aircon = 1'b0;
                fan = fan_on;
            end
        endcase
    end

endmodule