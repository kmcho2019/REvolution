module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output fan
);

    // Define states
    parameter IDLE    = 2'b00;
    parameter HEATING = 2'b01;
    parameter COOLING = 2'b10;
    
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (mode && too_cold)
                    next_state = HEATING;
                else if (!mode && too_hot)
                    next_state = COOLING;
                else
                    next_state = IDLE;
            end
            HEATING: begin
                if (!mode || !too_cold)
                    next_state = IDLE;
                else
                    next_state = HEATING;
            end
            COOLING: begin
                if (mode || !too_hot)
                    next_state = IDLE;
                else
                    next_state = COOLING;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic based on state
    always @(*) begin
        heater = (current_state == HEATING);
        aircon = (current_state == COOLING);
    end

    // Fan control (combinational)
    assign fan = heater | aircon | fan_on;

    // State register (would be clocked in a real implementation)
    initial current_state = IDLE;
    always @(*) current_state = next_state;

endmodule