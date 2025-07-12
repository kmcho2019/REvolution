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
    localparam S_IDLE     = 3'b000;
    localparam S_HEATING  = 3'b001;
    localparam S_COOLING  = 3'b010;
    localparam S_FAN_ONLY = 3'b100;
    
    reg [2:0] state;

    // Next state logic
    always @(*) begin
        if (fan_on) begin
            state = S_FAN_ONLY;
        end
        else if (mode && too_cold) begin
            state = S_HEATING;
        end
        else if (!mode && too_hot) begin
            state = S_COOLING;
        end
        else begin
            state = S_IDLE;
        end
    end

    // Output logic - each output has its own explicit enable condition
    assign heater = (state == S_HEATING);
    assign aircon = (state == S_COOLING);
    assign fan = (state != S_IDLE);  // Fan is on in all non-idle states

endmodule