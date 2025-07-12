module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater enabled only in heating mode and if too cold
    assign heater = mode & too_cold;

    // Air conditioner enabled only in cooling mode and if too hot
    assign aircon = (~mode) & too_hot;

    // Fan enabled if heater or aircon is on, or if user requests it
    assign fan = heater | aircon | fan_on;

endmodule