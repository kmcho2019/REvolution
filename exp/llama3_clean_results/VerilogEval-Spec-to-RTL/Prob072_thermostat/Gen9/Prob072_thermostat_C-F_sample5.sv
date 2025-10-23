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
        // Directly assign heater based on mode and too_cold
        heater = mode & too_cold;
        
        // Directly assign aircon based on mode and too_hot
        aircon = ~mode & too_hot;
        
        // Optimize fan logic by reusing heater and aircon signals
        fan = (heater | aircon) | fan_on;
    end

endmodule