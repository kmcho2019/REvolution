module TopModule(
    input logic mode,
    input logic too_cold,
    input logic too_hot,
    input logic fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    always_comb begin
        // Directly assign heater and aircon based on mode and temperature conditions
        heater = mode && too_cold;
        aircon = ~mode && too_hot;
        
        // Simplified logic for fan by directly considering the states of heater and aircon
        fan = heater || aircon || fan_on;
    end

endmodule