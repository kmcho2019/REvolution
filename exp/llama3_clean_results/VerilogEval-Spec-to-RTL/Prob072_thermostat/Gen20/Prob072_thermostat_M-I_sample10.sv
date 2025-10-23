module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*) begin
        // Calculate the heater signal based on mode and too_cold
        heater = mode & too_cold;
        
        // Calculate the aircon signal based on mode and too_hot
        aircon = ~mode & too_hot;
        
        // Combine the conditions for the fan signal into a single expression
        fan = (mode & too_cold) || (~mode & too_hot) || fan_on;
    end

endmodule