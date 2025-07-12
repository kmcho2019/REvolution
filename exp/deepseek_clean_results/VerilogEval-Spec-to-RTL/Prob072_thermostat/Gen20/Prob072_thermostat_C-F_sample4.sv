module TopModule (
    input  mode,       // 1=heating, 0=cooling
    input  too_cold,   // Needs heating
    input  too_hot,    // Needs cooling
    input  fan_on,     // Manual fan control
    output heater,     // Heater control
    output aircon,     // Air conditioner control
    output fan         // Fan control
);

    // Optional debug states (comment out for minimal implementation)
    // localparam IDLE     = 2'b00;
    // localparam HEATING  = 2'b01;
    // localparam COOLING  = 2'b10;
    // localparam FAN_ONLY = 2'b11;
    // reg [1:0] state;

    // Core functionality - optimized combinational logic
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan = fan_on | (heater | aircon);  // Parentheses show logical grouping

    // Optional state tracking (uncomment for debug)
    /*
    always @(*) begin
        if (heater)        state = HEATING;
        else if (aircon)   state = COOLING;
        else if (fan_on)   state = FAN_ONLY;
        else               state = IDLE;
    end
    */

endmodule