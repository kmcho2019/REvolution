module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    always_comb begin
        case (mode)
            1'b1: begin // heating mode
                heater = too_cold;
                aircon = 1'b0;
            end
            1'b0: begin // cooling mode
                heater = 1'b0;
                aircon = too_hot;
            end
            default: begin
                heater = 1'b0;
                aircon = 1'b0;
            end
        endcase
        // Reuse heater and aircon signals to drive fan
        fan = (heater | aircon) | fan_on;
    end

endmodule