module TopModule(
    input  mode,
    input  too_cold,
    input  too_hot,
    input  fan_on,
    output heater,
    output aircon,
    output fan
);

    // Define states to clarify operational modes
    localparam IDLE   = 2'b00;
    localparam HEAT   = 2'b01;
    localparam COOL   = 2'b10;

    reg [1:0] state;

    always @(*) begin
        if (mode) begin  // heating mode
            if (too_cold)
                state = HEAT;
            else
                state = IDLE;
        end else begin    // cooling mode
            if (too_hot)
                state = COOL;
            else
                state = IDLE;
        end
    end

    assign heater = (state == HEAT);
    assign aircon = (state == COOL);
    assign fan    = (state != IDLE) | fan_on;

endmodule