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
    parameter HEAT = 2'b00, COOL = 2'b01, FAN_ONLY = 2'b10, IDLE = 2'b11;

    always @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        case (state)
            HEAT: begin
                if (~mode) state = IDLE;
                else if (too_hot) state = IDLE;
            end
            COOL: begin
                if (mode) state = IDLE;
                else if (~too_hot) state = IDLE;
            end
            FAN_ONLY: begin
                if (mode & too_cold) state = HEAT;
                else if (~mode & too_hot) state = COOL;
                else if (~fan_on) state = IDLE;
            end
            IDLE: begin
                if (mode & too_cold) state = HEAT;
                else if (~mode & too_hot) state = COOL;
                else if (fan_on) state = FAN_ONLY;
            end
            default: state = IDLE;
        endcase
    end

    always @(*) begin
        case (state)
            HEAT: begin
                heater = 1'b1;
                aircon = 1'b0;
                fan = 1'b1;
            end
            COOL: begin
                heater = 1'b0;
                aircon = 1'b1;
                fan = 1'b1;
            end
            FAN_ONLY: begin
                heater = 1'b0;
                aircon = 1'b0;
                fan = 1'b1;
            end
            IDLE: begin
                heater = 1'b0;
                aircon = 1'b0;
                fan = 1'b0;
            end
            default: begin
                heater = 1'b0;
                aircon = 1'b0;
                fan = 1'b0;
            end
        endcase
    end

endmodule