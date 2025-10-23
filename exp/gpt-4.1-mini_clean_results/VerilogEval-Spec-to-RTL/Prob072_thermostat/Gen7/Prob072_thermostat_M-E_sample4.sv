module TopModule(
    input  mode,       // 1 = heating mode, 0 = cooling mode
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Define states as localparams for clarity (though not strictly needed here)
    localparam IDLE    = 2'b00;
    localparam HEATING = 2'b01;
    localparam COOLING = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;

    // Next state logic: combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (mode && too_cold)
                    next_state = HEATING;
                else if (~mode && too_hot)
                    next_state = COOLING;
                else
                    next_state = IDLE;
            end
            HEATING: begin
                if (~mode || !too_cold)
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

    // State update logic: because no clock input, model immediate update for simulation
    always @(*) begin
        state = next_state;
    end

    // Output logic based on state and fan_on
    always @(*) begin
        case (state)
            HEATING: begin
                heater = 1'b1;
                aircon = 1'b0;
            end
            COOLING: begin
                heater = 1'b0;
                aircon = 1'b1;
            end
            default: begin
                heater = 1'b0;
                aircon = 1'b0;
            end
        endcase

        // Fan is on if heater or aircon is on, or user fan_on is set
        fan = heater | aircon | fan_on;
    end

endmodule