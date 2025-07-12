module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    wire heater_signal = mode & too_cold;
    wire aircon_signal = ~mode & too_hot;

    assign heater = heater_signal;
    assign aircon = aircon_signal;
    assign fan    = heater_signal | aircon_signal | fan_on;

endmodule