module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    always_comb begin
        case (mode)
            1'b0: begin // Cooling mode
                aircon = too_hot;
                heater = 1'b0;
            end
            1'b1: begin // Heating mode
                heater = too_cold;
                aircon = 1'b0;
            end
            default: begin
                aircon = 1'b0;
                heater = 1'b0;
            end
        endcase

        fan = (heater | aircon) | fan_on;
    end

endmodule