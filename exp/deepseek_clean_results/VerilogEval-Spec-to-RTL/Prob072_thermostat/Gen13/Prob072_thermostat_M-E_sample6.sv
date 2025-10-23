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
    localparam IDLE    = 2'b00;
    localparam HEATING = 2'b01;
    localparam COOLING = 2'b10;

    reg [1:0] state;

    // State transition and output logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (mode && too_cold) state = HEATING;
                else if (!mode && too_hot) state = COOLING;
                else state = IDLE;
            end
            HEATING: begin
                if (!mode || !too_cold) state = IDLE;
                else state = HEATING;
            end
            COOLING: begin
                if (mode || !too_hot) state = IDLE;
                else state = COOLING;
            end
            default: state = IDLE;
        endcase

        // Temperature control outputs
        heater = (state == HEATING);
        aircon = (state == COOLING);
    end

    // Fan control (priority to user request)
    always @(*) begin
        fan = fan_on || (state != IDLE);
    end

endmodule