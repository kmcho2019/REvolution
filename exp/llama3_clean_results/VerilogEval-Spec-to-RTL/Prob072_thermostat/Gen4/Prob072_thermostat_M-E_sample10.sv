module TopModule(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    reg [1:0] state; // 2-bit state register
    parameter IDLE = 2'b00, HEATING = 2'b01, COOLING = 2'b10;

    always @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        case (state)
            IDLE: begin
                if (mode && too_cold) state <= HEATING;
                else if (~mode && too_hot) state <= COOLING;
                else state <= IDLE;
            end
            HEATING: begin
                if (~too_cold) state <= IDLE;
                else state <= HEATING;
            end
            COOLING: begin
                if (~too_hot) state <= IDLE;
                else state <= COOLING;
            end
            default: state <= IDLE;
        endcase
    end

    always @(*) begin
        case (state)
            IDLE: begin
                heater <= 0;
                aircon <= 0;
                fan <= fan_on;
            end
            HEATING: begin
                heater <= 1;
                aircon <= 0;
                fan <= 1;
            end
            COOLING: begin
                heater <= 0;
                aircon <= 1;
                fan <= 1;
            end
            default: begin
                heater <= 0;
                aircon <= 0;
                fan <= 0;
            end
        endcase
    end

endmodule