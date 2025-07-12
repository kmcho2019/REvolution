module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    always_comb begin
        // Use assign within always_comb for clarity and efficiency
        assign heater = mode && too_cold;
        assign aircon = ~mode && too_hot;
        assign fan = (heater || aircon) || fan_on;
    end

endmodule