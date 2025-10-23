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
    localparam [1:0] IDLE     = 2'b00;
    localparam [1:0] HEATING  = 2'b01;
    localparam [1:0] COOLING  = 2'b10;
    localparam [1:0] FAN_ONLY = 2'b11;

    reg [1:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (fan_on)
                    next_state = FAN_ONLY;
                else if (mode && too_cold)
                    next_state = HEATING;
                else if (!mode && too_hot)
                    next_state = COOLING;
                else
                    next_state = IDLE;
            end
            HEATING: begin
                if (fan_on)
                    next_state = FAN_ONLY;
                else if (!mode || !too_cold)
                    next_state = IDLE;
                else
                    next_state = HEATING;
            end
            COOLING: begin
                if (fan_on)
                    next_state = FAN_ONLY;
                else if (mode || !too_hot)
                    next_state = IDLE;
                else
                    next_state = COOLING;
            end
            FAN_ONLY: begin
                if (!fan_on) begin
                    if (mode && too_cold)
                        next_state = HEATING;
                    else if (!mode && too_hot)
                        next_state = COOLING;
                    else
                        next_state = IDLE;
                end else
                    next_state = FAN_ONLY;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            HEATING:  {heater, aircon, fan} = 3'b101;
            COOLING:  {heater, aircon, fan} = 3'b011;
            FAN_ONLY: {heater, aircon, fan} = 3'b001;
            default:  {heater, aircon, fan} = 3'b000;
        endcase
    end

    // State register (would be clocked in real implementation)
    initial current_state = IDLE;
    always @(*) current_state = next_state;

endmodule