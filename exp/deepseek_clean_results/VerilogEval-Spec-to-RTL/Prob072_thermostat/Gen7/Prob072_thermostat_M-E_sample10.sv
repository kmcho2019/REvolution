module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heating mode takes priority when active
    wire heating_active = mode & too_cold;
    wire cooling_active = ~mode & too_hot;

    // Output assignments
    assign heater = heating_active;
    assign aircon = cooling_active;
    
    // Fan activates for any active system or manual request
    assign fan = heating_active | cooling_active | fan_on;

endmodule