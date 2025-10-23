module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output wire fan
);

    // Intermediate signals indicating requirement for heating or cooling
    wire heating_needed = mode & too_cold;
    wire cooling_needed = (~mode) & too_hot;

    always @(*) begin
        if (heating_needed) begin
            heater = 1'b1;
            aircon = 1'b0;
        end else if (cooling_needed) begin
            heater = 1'b0;
            aircon = 1'b1;
        end else begin
            heater = 1'b0;
            aircon = 1'b0;
        end
    end

    // Fan is on if heater or aircon is on, or if fan_on is requested
    assign fan = heater | aircon | fan_on;

endmodule