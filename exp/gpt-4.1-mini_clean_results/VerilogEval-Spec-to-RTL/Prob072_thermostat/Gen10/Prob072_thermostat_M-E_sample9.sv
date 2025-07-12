module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    typedef enum reg [1:0] {
        IDLE = 2'b00,
        HEATING = 2'b01,
        COOLING = 2'b10
    } state_t;

    state_t state, next_state;

    // State register
    always @(posedge mode or posedge too_cold or posedge too_hot) begin
        // Use level-sensitive style with combinational next state logic (simplified)
        state <= next_state;
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (mode && too_cold)
                    next_state = HEATING;
                else if (!mode && too_hot)
                    next_state = COOLING;
                else
                    next_state = IDLE;
            end

            HEATING: begin
                // Stay heating if conditions still hold
                if (mode && too_cold)
                    next_state = HEATING;
                else
                    next_state = IDLE;
            end

            COOLING: begin
                // Stay cooling if conditions still hold
                if (!mode && too_hot)
                    next_state = COOLING;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Outputs logic
    always @(*) begin
        heater = 1'b0;
        aircon = 1'b0;
        case (state)
            HEATING: heater = 1'b1;
            COOLING: aircon = 1'b1;
            default: ;
        endcase
        fan = heater | aircon | fan_on;
    end

endmodule