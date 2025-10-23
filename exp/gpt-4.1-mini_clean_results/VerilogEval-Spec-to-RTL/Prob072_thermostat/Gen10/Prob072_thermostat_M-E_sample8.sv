module TopModule (
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output reg heater,
    output reg aircon,
    output fan
);

    reg heater_reg;
    reg aircon_reg;

    // Combinational logic for heater and aircon outputs
    always @(*) begin
        if (mode) begin
            heater_reg = too_cold;
            aircon_reg = 1'b0;
        end else begin
            heater_reg = 1'b0;
            aircon_reg = too_hot;
        end
    end

    // Assign outputs
    always @(*) begin
        heater = heater_reg;
        aircon = aircon_reg;
    end

    // Fan is on if fan_on is asserted or heater/aircon is on
    assign fan = fan_on | heater_reg | aircon_reg;

endmodule