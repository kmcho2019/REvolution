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
        // Directly assign heater condition
        heater = mode && too_cold;
        
        // Directly assign aircon condition
        aircon = ~mode && too_hot;
        
        // Directly assign fan condition, considering heater, aircon, and fan_on
        fan = (mode && too_cold) || (~mode && too_hot) || fan_on;
    end

endmodule