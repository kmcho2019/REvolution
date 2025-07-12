module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // State encoding
    // 2'b00 = OFF
    // 2'b01 = HEATING
    // 2'b10 = COOLING
    reg [1:0] state;
    reg [1:0] next_state;

    // Determine next state combinationally based on inputs
    always @(*) begin
        case (state)
            2'b00: begin
                if (mode && too_cold)
                    next_state = 2'b01; // heating
                else if (~mode && too_hot)
                    next_state = 2'b10; // cooling
                else
                    next_state = 2'b00; // off
            end
            2'b01: begin
                // stay heating only while still too cold in heating mode
                if (mode && too_cold)
                    next_state = 2'b01;
                else
                    next_state = 2'b00;
            end
            2'b10: begin
                // stay cooling only while still too hot in cooling mode
                if (~mode && too_hot)
                    next_state = 2'b10;
                else
                    next_state = 2'b00;
            end
            default: next_state = 2'b00;
        endcase
    end

    // Combinational outputs based on next state
    assign heater = (next_state == 2'b01);
    assign aircon = (next_state == 2'b10);
    assign fan    = heater | aircon | fan_on;

    // Since no clock is specified, model state as combinational feedback
    // This is just for architectural illustration; in practical designs a clock is needed.
    always @(*) begin
        state = next_state;
    end

endmodule