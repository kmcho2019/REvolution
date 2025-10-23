module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    reg [1:0] state;
    reg [1:0] next_state;

    // State encoding: 00 - idle, 01 - heating, 10 - cooling, 11 - fan_only

    always @(*) begin
        case(state)
            2'b00: // idle
                if (mode && too_cold) next_state = 2'b01;
                else if (~mode && too_hot) next_state = 2'b10;
                else if (fan_on) next_state = 2'b11;
                else next_state = 2'b00;
            2'b01: // heating
                if (~mode || ~too_cold) next_state = 2'b00;
                else if (fan_on) next_state = 2'b01;
                else next_state = 2'b01;
            2'b10: // cooling
                if (mode || ~too_hot) next_state = 2'b00;
                else if (fan_on) next_state = 2'b10;
                else next_state = 2'b10;
            2'b11: // fan_only
                if (~fan_on) next_state = 2'b00;
                else next_state = 2'b11;
            default: next_state = 2'b00;
        endcase
    end

    always @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        state <= next_state;
    end

    assign heater = (state == 2'b01);
    assign aircon = (state == 2'b10);
    assign fan = (state == 2'b01 || state == 2'b10 || state == 2'b11);

endmodule