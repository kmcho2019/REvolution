module TopModule (
    input  clk,
    input  reset,
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // State encoding
    typedef enum logic [0:0] {
        OFF = 1'b0,
        FAN_ON = 1'b1
    } state_t;

    state_t current_state, next_state;

    // Next state logic and outputs combinational
    always @(*) begin
        // Default outputs
        heater  = 0;
        aircon  = 0;
        fan     = 0;
        next_state = current_state;

        // Heater or aircon decision
        case (mode)
            1'b1: heater = too_cold;        // heating mode: heater on if too cold
            1'b0: aircon = too_hot;         // cooling mode: aircon on if too hot
        endcase

        case (current_state)
            OFF: begin
                if (heater || aircon || fan_on)
                    next_state = FAN_ON;
            end

            FAN_ON: begin
                fan = 1;
                if (!(heater || aircon || fan_on))
                    next_state = OFF;
            end
        endcase
    end

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= OFF;
        else
            current_state <= next_state;
    end

endmodule