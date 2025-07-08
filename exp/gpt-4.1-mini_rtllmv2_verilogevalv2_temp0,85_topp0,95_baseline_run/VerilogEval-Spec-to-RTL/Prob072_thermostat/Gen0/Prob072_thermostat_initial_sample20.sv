module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is on in heating mode and when too_cold is true
    assign heater = mode & too_cold;

    // Aircon is on in cooling mode and when too_hot is true
    assign aircon = (~mode) & too_hot;

    // Fan is on if heater or aircon is on, or if fan_on input is asserted
    assign fan = heater | aircon | fan_on;

endmodule