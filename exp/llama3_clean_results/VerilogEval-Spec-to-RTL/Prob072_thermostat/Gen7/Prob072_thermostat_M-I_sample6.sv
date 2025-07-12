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
        // Initialize outputs to default (off) state
        heater = 0;
        aircon = 0;
        fan = 0;
        
        // Conditionally turn on heater or aircon based on mode
        if (mode && too_cold) begin
            heater = 1;
        end else if (~mode && too_hot) begin
            aircon = 1;
        end
        
        // Turn on fan if heater or aircon is on, or if fan_on is high
        fan = (heater || aircon || fan_on);
    end

endmodule