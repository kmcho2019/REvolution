module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // One-hot state encoding
    localparam HEATER_OFF = 2'b01;
    localparam HEATER_ON  = 2'b10;
    
    reg [1:0] heater_state;
    reg aircon_enable;
    reg fan_force;

    // Heater control with priority
    always @(*) begin
        if (mode && too_cold) begin
            heater_state = HEATER_ON;
        end else begin
            heater_state = HEATER_OFF;
        end
    end

    // Aircon control (lower priority than heater)
    always @(*) begin
        if (!mode && too_hot && heater_state == HEATER_OFF) begin
            aircon_enable = 1'b1;
        end else begin
            aircon_enable = 1'b0;
        end
    end

    // Fan control with override capability
    always @(*) begin
        fan_force = fan_on && (heater_state == HEATER_OFF) && !aircon_enable;
    end

    // Output assignments
    assign heater = (heater_state == HEATER_ON);
    assign aircon = aircon_enable;
    assign fan = (heater_state == HEATER_ON) || aircon_enable || fan_force;

endmodule