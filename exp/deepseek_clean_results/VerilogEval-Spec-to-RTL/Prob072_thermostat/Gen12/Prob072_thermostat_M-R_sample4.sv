module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Mode definitions for code clarity
    localparam HEATING = 1'b1;
    localparam COOLING = 1'b0;

    always @(*) begin
        // Default outputs
        heater = 1'b0;
        aircon = 1'b0;

        case (mode)
            HEATING: heater = too_cold;
            COOLING: aircon = too_hot;
        endcase

        // Fan control remains the same
        fan = fan_on | heater | aircon;
    end

endmodule