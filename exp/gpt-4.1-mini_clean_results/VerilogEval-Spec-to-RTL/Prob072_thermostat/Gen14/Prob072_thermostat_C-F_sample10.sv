module TopModule (
    input  mode,       // 1: heating mode, 0: cooling mode
    input  too_cold,   // 1 if temperature is too cold
    input  too_hot,    // 1 if temperature is too hot
    input  fan_on,     // User request to turn on fan
    output heater,     // Heater control output
    output aircon,     // Air conditioner control output
    output fan         // Fan control output
);

    localparam HEAT = 1'b1;
    localparam COOL = 1'b0;

    wire heater_int  = (mode == HEAT) & too_cold;
    wire aircon_int  = (mode == COOL) & too_hot;

    assign heater = heater_int;
    assign aircon = aircon_int;

    assign fan = heater_int | aircon_int | fan_on;

endmodule