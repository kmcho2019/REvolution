module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // State encoding
    localparam [1:0] IDLE     = 2'b00;
    localparam [1:0] HEATING  = 2'b01;
    localparam [1:0] COOLING  = 2'b10;
    localparam [1:0] FAN_ONLY = 2'b11;

    reg [1:0] state;

    always @(*) begin
        case (state)
            IDLE: begin
                if (fan_on) state = FAN_ONLY;
                else if (mode && too_cold) state = HEATING;
                else if (!mode && too_hot) state = COOLING;
                else state = IDLE;
            end
            HEATING: begin
                if (fan_on) state = FAN_ONLY;
                else if (!mode || !too_cold) state = IDLE;
                else state = HEATING;
            end
            COOLING: begin
                if (fan_on) state = FAN_ONLY;
                else if (mode || !too_hot) state = IDLE;
                else state = COOLING;
            end
            FAN_ONLY: begin
                if (!fan_on) begin
                    if (mode && too_cold) state = HEATING;
                    else if (!mode && too_hot) state = COOLING;
                    else state = IDLE;
                end
                else state = FAN_ONLY;
            end
        endcase
    end

    assign heater = (state == HEATING);
    assign aircon  = (state == COOLING);
    assign fan     = (state == HEATING) || (state == COOLING) || (state == FAN_ONLY);

endmodule