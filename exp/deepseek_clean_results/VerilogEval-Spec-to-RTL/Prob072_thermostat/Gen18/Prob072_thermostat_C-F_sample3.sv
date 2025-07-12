module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    /* Optional debug state tracking (uncomment if needed)
    localparam IDLE     = 2'b00;
    localparam HEATING  = 2'b01;
    localparam COOLING  = 2'b10;
    localparam FAN_ONLY = 2'b11;
    reg [1:0] state;
    */

    // Optimal combinational logic
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan = fan_on | heater | aircon;

    /* Optional state tracking (uncomment if needed)
    always @(*) begin
        if (heater)        state = HEATING;
        else if (aircon)   state = COOLING;
        else if (fan_on)   state = FAN_ONLY;
        else               state = IDLE;
    end
    */

endmodule