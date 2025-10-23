module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(*) begin
    // Initialize outputs to 0
    heater = 0;
    aircon = 0;
    fan = 0;

    // In heating mode
    if (mode) begin
        if (too_cold) begin
            heater = 1;
            fan = 1;
        end
        // Turn on fan if user requests it
        if (fan_on) begin
            fan = 1;
        end
    end
    // In cooling mode
    else begin
        if (too_hot) begin
            aircon = 1;
            fan = 1;
        end
        // Turn on fan if user requests it
        if (fan_on) begin
            fan = 1;
        end
    end
end

endmodule