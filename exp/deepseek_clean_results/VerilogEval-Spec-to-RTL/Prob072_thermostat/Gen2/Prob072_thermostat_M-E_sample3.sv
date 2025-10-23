module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output fan
);

    // State encoding
    localparam HEATING = 1'b1;
    localparam COOLING = 1'b0;

    // State-dependent outputs
    always @(*) begin
        case (mode)
            HEATING: begin
                heater = too_cold;
                aircon = 1'b0;
            end
            COOLING: begin
                heater = 1'b0;
                aircon = too_hot;
            end
            default: begin
                heater = 1'b0;
                aircon = 1'b0;
            end
        endcase
    end

    // Fan is combinational logic
    assign fan = heater | aircon | fan_on;

endmodule