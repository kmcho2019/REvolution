module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    // Directly assign outputs based on input conditions
    always_comb begin
        heater = mode && too_cold;
        aircon = !mode && too_hot;
        fan = (mode && too_cold) || (!mode && too_hot) || fan_on;
    end

endmodule