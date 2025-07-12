module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Priority-based control logic
    wire temp_control_active;
    wire heater_req = mode & too_cold;
    wire aircon_req = ~mode & too_hot;
    
    // Priority selection: fan_on > aircon > heater
    assign temp_control_active = fan_on ? 1'b0 : (aircon_req ? 1'b1 : heater_req);
    
    // Output assignments
    assign fan = fan_on | aircon_req | heater_req;
    assign aircon = temp_control_active & aircon_req;
    assign heater = temp_control_active & heater_req;

endmodule