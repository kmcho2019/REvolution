module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // FSM states
    localparam IDLE     = 2'b00;
    localparam HEATING  = 2'b01;
    localparam COOLING  = 2'b10;
    localparam FAN_ONLY = 2'b11;

    reg [1:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (mode && too_cold)
                    next_state = HEATING;
                else if (!mode && too_hot)
                    next_state = COOLING;
                else if (fan_on)
                    next_state = FAN_ONLY;
                else
                    next_state = IDLE;
            end
            HEATING: begin
                if (!mode || !too_cold)
                    next_state = fan_on ? FAN_ONLY : IDLE;
                else
                    next_state = HEATING;
            end
            COOLING: begin
                if (mode || !too_hot)
                    next_state = fan_on ? FAN_ONLY : IDLE;
                else
                    next_state = COOLING;
            end
            FAN_ONLY: begin
                if (mode && too_cold)
                    next_state = HEATING;
                else if (!mode && too_hot)
                    next_state = COOLING;
                else if (!fan_on)
                    next_state = IDLE;
                else
                    next_state = FAN_ONLY;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        heater = 0;
        aircon = 0;
        fan = 0;
        
        case (current_state)
            HEATING: begin
                heater = 1;
                fan = 1;
            end
            COOLING: begin
                aircon = 1;
                fan = 1;
            end
            FAN_ONLY: begin
                fan = 1;
            end
            default: ; // IDLE state - all outputs remain 0
        endcase
    end

    // State register (could add clock and reset for synchronous version)
    initial current_state = IDLE;
    always @(*) current_state = next_state;

endmodule