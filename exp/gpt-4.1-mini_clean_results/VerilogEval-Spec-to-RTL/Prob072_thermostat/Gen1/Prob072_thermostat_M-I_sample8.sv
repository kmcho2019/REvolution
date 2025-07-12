module TopModule (
    input  mode,       // 1: heating mode, 0: cooling mode
    input  too_cold,   // temperature below setpoint
    input  too_hot,    // temperature above setpoint
    input  fan_on,     // user fan request override
    output wire heater,
    output wire aircon,
    output wire fan
);

// Heater on when heating mode and too cold
assign heater = mode & too_cold;

// Air conditioner on when cooling mode and too hot
assign aircon = (~mode) & too_hot;

// Fan on if heater or aircon is on, or user requests fan
assign fan = heater | aircon | fan_on;

endmodule