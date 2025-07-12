module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output reg fan
);

    // In heating mode, turn the heater on when it's too cold
    assign heater = mode & too_cold;

    // In cooling mode, turn the air conditioner on when it's too hot
    assign aircon = ~mode & too_hot;

    // Turn the fan on when the heater or air conditioner is on, or if fan_on is asserted
    // Using a single always block to reduce combinational logic area
    always @(*) begin
        fan = 0;
        if (heater || aircon || fan_on) begin
            fan = 1;
        end
    end

endmodule