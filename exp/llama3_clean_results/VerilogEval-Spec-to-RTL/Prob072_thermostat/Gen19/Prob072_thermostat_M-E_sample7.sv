module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Define states
    reg [1:0] state; // 2 bits for 4 possible states, but we use only 3
    parameter IDLE = 2'b00, HEATING = 2'b01, COOLING = 2'b10;

    // Default state is IDLE
    initial state = IDLE;

    always @(*) begin
        case(state)
            IDLE: begin
                if (mode) begin // Request to heat
                    state = HEATING;
                end else if (~mode) begin // Request to cool
                    state = COOLING;
                end
            end
            HEATING: begin
                if (~mode) begin // Switch to cooling mode
                    state = COOLING;
                end
            end
            COOLING: begin
                if (mode) begin // Switch to heating mode
                    state = HEATING;
                end
            end
            default: state = IDLE; // Invalid state, return to IDLE
        endcase
    end

    // Actions based on state
    always @(*) begin
        case(state)
            IDLE: begin
                heater = 1'b0;
                aircon = 1'b0;
                fan = fan_on;
            end
            HEATING: begin
                heater = too_cold;
                aircon = 1'b0;
                fan = too_cold | fan_on;
            end
            COOLING: begin
                heater = 1'b0;
                aircon = too_hot;
                fan = too_hot | fan_on;
            end
            default: begin
                heater = 1'b0;
                aircon = 1'b0;
                fan = 1'b0;
            end
        endcase
    end

endmodule