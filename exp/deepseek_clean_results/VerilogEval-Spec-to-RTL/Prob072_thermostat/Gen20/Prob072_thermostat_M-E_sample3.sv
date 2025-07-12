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
    localparam IDLE = 2'b00;
    localparam HEAT = 2'b01;
    localparam COOL = 2'b10;
    
    reg [1:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (mode && too_cold)       next_state = HEAT;
                else if (!mode && too_hot)  next_state = COOL;
                else                       next_state = IDLE;
            end
            HEAT: begin
                if (!mode || !too_cold)     next_state = IDLE;
                else                        next_state = HEAT;
            end
            COOL: begin
                if (mode || !too_hot)       next_state = IDLE;
                else                        next_state = COOL;
            end
            default:                        next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk) begin
        current_state <= next_state;
    end

    // Output logic
    always @(*) begin
        heater = (current_state == HEAT);
        aircon = (current_state == COOL);
        fan = fan_on || (current_state != IDLE);
    end

endmodule