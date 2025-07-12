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
    parameter HEAT = 2'b01, COOL = 2'b10, IDLE = 2'b00;

    always @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        case(state)
            IDLE: begin
                if (mode & too_cold) state <= HEAT;
                else if (~mode & too_hot) state <= COOL;
            end
            HEAT: begin
                if (~mode | ~too_cold) state <= IDLE;
            end
            COOL: begin
                if (mode | ~too_hot) state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end

    assign heater = (state == HEAT);
    assign aircon = (state == COOL);
    assign fan = (state == HEAT) | (state == COOL) | fan_on;

endmodule