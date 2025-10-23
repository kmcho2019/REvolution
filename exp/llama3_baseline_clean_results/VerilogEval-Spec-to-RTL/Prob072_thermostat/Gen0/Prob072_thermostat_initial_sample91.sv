module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    always @(mode, too_cold, too_hot, fan_on) begin
        if (mode == 1'b1) begin // heating mode
            if (too_cold == 1'b1) begin
                heater = 1'b1;
                fan = 1'b1;
            end else begin
                heater = 1'b0;
                fan = fan_on ? 1'b1 : 1'b0;
            end
            aircon = 1'b0;
        end else begin // cooling mode
            if (too_hot == 1'b1) begin
                aircon = 1'b1;
                fan = 1'b1;
            end else begin
                aircon = 1'b0;
                fan = fan_on ? 1'b1 : 1'b0;
            end
            heater = 1'b0;
        end
    end

endmodule