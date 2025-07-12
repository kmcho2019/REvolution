module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    wire active = (mode & too_cold) | (~mode & too_hot);

    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan    = active | fan_on;

endmodule