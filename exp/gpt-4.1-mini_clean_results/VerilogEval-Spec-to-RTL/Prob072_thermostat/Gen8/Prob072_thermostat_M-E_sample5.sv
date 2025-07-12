module TopModule (
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output heater,    // Heater control output
    output aircon,    // Air conditioner control output
    output fan        // Fan control output
);

    // State encoding as parameters for clarity
    localparam [1:0] 
        STATE_OFF     = 2'b00,
        STATE_HEATING = 2'b01,
        STATE_COOLING = 2'b10;

    reg [1:0] state;

    // Combinational next state logic: since no clock is specified,
    // next state depends only on inputs to produce a stable state output
    // modeling a stateless FSM for clarity.
    always @(*) begin
        if (mode) begin // heating mode
            if (too_cold)
                state = STATE_HEATING;
            else
                state = STATE_OFF;
        end
        else begin // cooling mode
            if (too_hot)
                state = STATE_COOLING;
            else
                state = STATE_OFF;
        end
    end

    // Outputs depend on current state
    assign heater = (state == STATE_HEATING) ? 1'b1 : 1'b0;
    assign aircon = (state == STATE_COOLING) ? 1'b1 : 1'b0;

    // Fan on if heater or aircon is on, or user manually turns fan on
    assign fan = heater | aircon | fan_on;

endmodule