module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

always @(*) begin
    // Initialize outputs to default (off) state
    heater = 0;
    aircon = 0;
    fan = 0;

    // Check the mode of operation
    if (mode) begin // Heating mode
        if (too_cold) begin // It's too cold, turn on the heater and fan
            heater = 1;
            fan = 1;
        end else if (fan_on) begin // If it's not too cold but fan_on is requested, turn on the fan
            fan = 1;
        end
    end else begin // Cooling mode
        if (too_hot) begin // It's too hot, turn on the air conditioner and fan
            aircon = 1;
            fan = 1;
        end else if (fan_on) begin // If it's not too hot but fan_on is requested, turn on the fan
            fan = 1;
        end
    end
end

endmodule