module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // State encoding for debug/expansion (not used in output logic)
    localparam IDLE     = 2'b00;
    localparam HEATING  = 2'b01;
    localparam COOLING  = 2'b10;
    localparam FAN_ONLY = 2'b11;
    
    reg [1:0] state;

    // Direct combinational outputs (optimized)
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    assign fan = fan_on | heater | aircon;

    // State tracking (for debug/expansion)
    always @(*) begin
        if (heater)        state = HEATING;
        else if (aircon)   state = COOLING;
        else if (fan_on)   state = FAN_ONLY;
        else               state = IDLE;
    end

endmodule