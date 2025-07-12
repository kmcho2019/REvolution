module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    always_comb begin
        // Heating mode controls
        heater = mode & too_cold;
        aircon = ~mode & too_hot;
        
        // Fan control combines all activation conditions
        fan = heater | aircon | fan_on;
    end

endmodule