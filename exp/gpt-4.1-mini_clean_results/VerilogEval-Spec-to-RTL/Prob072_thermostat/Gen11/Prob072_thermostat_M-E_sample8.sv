module TopModule (
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output reg heater,    // Heater control output
    output reg aircon,    // Air conditioner control output
    output reg fan        // Fan control output
);

    localparam HEATING = 1'b1;
    localparam COOLING = 1'b0;

    reg current_mode;

    // Combinational logic to select mode and outputs
    always @(*) begin
        current_mode = mode;
        heater = 1'b0;
        aircon = 1'b0;
        fan = 1'b0;

        case (current_mode)
            HEATING: begin
                if (too_cold)
                    heater = 1'b1;
                aircon = 1'b0;
            end
            COOLING: begin
                heater = 1'b0;
                if (too_hot)
                    aircon = 1'b1;
            end
            default: begin
                heater = 1'b0;
                aircon = 1'b0;
            end
        endcase

        fan = heater | aircon | fan_on;
    end

endmodule