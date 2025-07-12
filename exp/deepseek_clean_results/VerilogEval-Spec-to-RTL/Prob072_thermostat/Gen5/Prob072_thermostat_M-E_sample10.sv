module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // State encoding
    localparam IDLE     = 2'b00;
    localparam HEATING  = 2'b01;
    localparam COOLING  = 2'b10;
    localparam FAN_ONLY = 2'b11;

    reg [1:0] state;

    always @(*) begin
        case (state)
            IDLE: begin
                if (mode && too_cold) begin
                    state = HEATING;
                end
                else if (!mode && too_hot) begin
                    state = COOLING;
                end
                else if (fan_on) begin
                    state = FAN_ONLY;
                end
                else begin
                    state = IDLE;
                end
            end
            HEATING: begin
                if (!mode || !too_cold) begin
                    if (fan_on) state = FAN_ONLY;
                    else state = IDLE;
                end
            end
            COOLING: begin
                if (mode || !too_hot) begin
                    if (fan_on) state = FAN_ONLY;
                    else state = IDLE;
                end
            end
            FAN_ONLY: begin
                if (!fan_on) begin
                    if (mode && too_cold) state = HEATING;
                    else if (!mode && too_hot) state = COOLING;
                    else state = IDLE;
                end
            end
        endcase

        // Output logic
        heater = (state == HEATING);
        aircon = (state == COOLING);
        fan = (state == HEATING) || (state == COOLING) || (state == FAN_ONLY);
    end

endmodule