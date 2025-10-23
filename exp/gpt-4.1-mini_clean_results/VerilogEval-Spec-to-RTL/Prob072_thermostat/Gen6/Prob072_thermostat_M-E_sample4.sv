module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam HEATING = 2'b01;
    localparam COOLING = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic
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
                // Remain heating as long as too cold in heating mode
                if (!mode || !too_cold)
                    next_state = IDLE;
                else
                    next_state = HEATING;
            end
            COOLING: begin
                // Remain cooling as long as too hot in cooling mode
                if (mode || !too_hot)
                    next_state = IDLE;
                else
                    next_state = COOLING;
            end
            default: next_state = IDLE;
        endcase
    end

    // State update on combinational logic (for simplicity, combinational FSM)
    always @(*) begin
        state = next_state;
    end

    // Output logic
    always @(*) begin
        heater = 1'b0;
        aircon = 1'b0;
        fan    = 1'b0;

        case (state)
            HEATING: begin
                heater = 1'b1;
                fan = 1'b1;
            end
            COOLING: begin
                aircon = 1'b1;
                fan = 1'b1;
            end
            IDLE: begin
                fan = fan_on;
            end
        endcase
    end

endmodule