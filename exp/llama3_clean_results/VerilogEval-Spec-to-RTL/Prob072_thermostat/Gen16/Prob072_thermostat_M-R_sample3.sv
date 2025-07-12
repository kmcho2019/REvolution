module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    always @(*) begin
        if (mode && too_cold) begin
            heater = 1'b1;
            aircon = 1'b0;
            fan = 1'b1;
        end else if (!mode && too_hot) begin
            heater = 1'b0;
            aircon = 1'b1;
            fan = 1'b1;
        end else begin
            heater = 1'b0;
            aircon = 1'b0;
            fan = fan_on;
        end
    end

endmodule