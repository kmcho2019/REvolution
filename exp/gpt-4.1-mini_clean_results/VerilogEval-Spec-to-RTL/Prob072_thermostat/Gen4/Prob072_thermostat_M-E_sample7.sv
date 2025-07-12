module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);
    // Define states
    localparam OFF     = 2'b00;
    localparam HEATING = 2'b01;
    localparam COOLING = 2'b10;

    // Combinational state logic
    reg [1:0] state;
    always @(*) begin
        if (mode) begin // Heating mode
            if (too_cold)
                state = HEATING;
            else
                state = OFF;
        end else begin // Cooling mode
            if (too_hot)
                state = COOLING;
            else
                state = OFF;
        end
    end

    // Outputs assigned based on state and fan_on
    assign heater = (state == HEATING);
    assign aircon = (state == COOLING);
    assign fan = fan_on | (state != OFF);

endmodule