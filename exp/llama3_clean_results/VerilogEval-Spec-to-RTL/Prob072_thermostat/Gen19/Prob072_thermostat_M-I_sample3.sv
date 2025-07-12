module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan = (mode & too_cold) | (~mode & too_hot) | fan_on;

    // Alternatively, the fan logic could be simplified by considering the conditions under which the fan would be on,
    // but given the current logic is already quite straightforward and optimized, the simplification might not yield significant PPA improvements.

endmodule