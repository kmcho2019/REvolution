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
        if (mode == 1) begin // heating mode
            heater = too_cold;
            aircon = 0;
        end else begin // cooling mode
            heater = 0;
            aircon = too_hot;
        end

        fan = (heater == 1) || (aircon == 1) || fan_on;
    end

endmodule