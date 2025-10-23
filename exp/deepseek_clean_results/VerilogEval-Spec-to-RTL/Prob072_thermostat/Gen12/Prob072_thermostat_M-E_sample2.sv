module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // State encoding
    localparam HEATING = 2'b00;
    localparam COOLING = 2'b01;
    localparam IDLE_HEAT = 2'b10;
    localparam IDLE_COOL = 2'b11;

    wire [1:0] state;
    assign state = mode ? (too_cold ? HEATING : IDLE_HEAT) 
                      : (too_hot ? COOLING : IDLE_COOL);

    always @(*) begin
        case (state)
            HEATING: begin
                heater = 1'b1;
                aircon = 1'b0;
                fan = 1'b1;
            end
            COOLING: begin
                heater = 1'b0;
                aircon = 1'b1;
                fan = 1'b1;
            end
            default: begin // IDLE states
                heater = 1'b0;
                aircon = 1'b0;
                fan = fan_on;
            end
        endcase
    end

endmodule