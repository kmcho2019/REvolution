module TopModule (
    input  mode, too_cold, too_hot, fan_on,
    output heater, aircon, fan
);

    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan = (mode & too_cold) | (~mode & too_hot) | fan_on;

endmodule