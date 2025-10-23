module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    reg [1:0] state;

    // Initialize the state machine
    initial state = 0;

    // State machine logic
    always @(*) begin
        case (state)
            0: begin // HEATING state
                if (too_cold) begin
                    heater = 1;
                    aircon = 0;
                end else begin
                    heater = 0;
                    aircon = 0;
                end
            end
            1: begin // COOLING state
                if (too_hot) begin
                    heater = 0;
                    aircon = 1;
                end else begin
                    heater = 0;
                    aircon = 0;
                end
            end
            default: begin
                heater = 0;
                aircon = 0;
            end
        endcase
    end

    // State transition logic
    always @(posedge mode) begin
        if (mode) begin
            state = 0; // Transition to HEATING state
        end else begin
            state = 1; // Transition to COOLING state
        end
    end

    // Fan control logic
    always @(*) begin
        if (heater || aircon || fan_on) begin
            fan = 1;
        end else begin
            fan = 0;
        end
    end

endmodule