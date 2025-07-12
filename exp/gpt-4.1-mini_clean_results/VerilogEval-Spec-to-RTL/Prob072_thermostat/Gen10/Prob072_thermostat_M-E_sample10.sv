module TopModule (
    input  mode,      // 1: heating mode, 0: cooling mode
    input  too_cold,  // 1 if temperature is too cold
    input  too_hot,   // 1 if temperature is too hot
    input  fan_on,    // User request to turn on fan
    output reg heater,    // Heater control output
    output reg aircon,    // Air conditioner control output
    output fan        // Fan control output
);

    // Define internal states representing current action
    localparam IDLE = 2'd0;
    localparam HEAT = 2'd1;
    localparam COOL = 2'd2;

    reg [1:0] state;

    // Combinational logic to determine state based on inputs
    always @(*) begin
        case (mode)
            1'b1: begin
                // Heating mode: heat if too cold, else idle
                if (too_cold)
                    state = HEAT;
                else
                    state = IDLE;
            end
            1'b0: begin
                // Cooling mode: cool if too hot, else idle
                if (too_hot)
                    state = COOL;
                else
                    state = IDLE;
            end
            default: state = IDLE;
        endcase
    end

    // Outputs derived from state
    always @(*) begin
        heater = (state == HEAT);
        aircon = (state == COOL);
    end

    // Fan is on if heater or aircon active or user requests fan
    assign fan = heater | aircon | fan_on;

endmodule