module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

reg [1:0] state; // 0: idle, 1: heating, 2: cooling, 3: fan_on

always @(*) begin
    case (state)
        0: begin // idle
            if (mode & too_cold) begin
                state = 1; // transition to heating
            end else if (~mode & too_hot) begin
                state = 2; // transition to cooling
            end else if (fan_on) begin
                state = 3; // transition to fan_on
            end
            heater = 0;
            aircon = 0;
            fan = 0;
        end
        1: begin // heating
            if (!(mode & too_cold)) begin
                state = 0; // transition to idle
            end
            heater = 1;
            aircon = 0;
            fan = 1;
        end
        2: begin // cooling
            if (!(~mode & too_hot)) begin
                state = 0; // transition to idle
            end
            heater = 0;
            aircon = 1;
            fan = 1;
        end
        3: begin // fan_on
            if (!fan_on) begin
                state = 0; // transition to idle
            end
            heater = 0;
            aircon = 0;
            fan = 1;
        end
        default: begin
            state = 0;
            heater = 0;
            aircon = 0;
            fan = 0;
        end
    endcase
end

initial begin
    state = 0; // initialize to idle state
end

endmodule