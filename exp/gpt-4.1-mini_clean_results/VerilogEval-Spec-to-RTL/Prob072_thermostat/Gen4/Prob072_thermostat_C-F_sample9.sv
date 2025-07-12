module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heater_on = mode & too_cold;
    wire aircon_on = ~mode & too_hot;

    assign heater = heater_on;
    assign aircon = aircon_on;
    assign fan    = heater_on | aircon_on | fan_on;

endmodule