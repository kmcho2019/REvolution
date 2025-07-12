module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // State encoding
    localparam [1:0] IDLE     = 2'b00;
    localparam [1:0] HEATING  = 2'b01;
    localparam [1:0] COOLING  = 2'b10;
    localparam [1:0] FAN_ONLY = 2'b11;

    reg [1:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (mode && too_cold) next_state = HEATING;
                else if (!mode && too_hot) next_state = COOLING;
                else if (fan_on) next_state = FAN_ONLY;
                else next_state = IDLE;
            end
            HEATING: begin
                if (!mode || !too_cold) next_state = fan_on ? FAN_ONLY : IDLE;
                else next_state = HEATING;
            end
            COOLING: begin
                if (mode || !too_hot) next_state = fan_on ? FAN_ONLY : IDLE;
                else next_state = COOLING;
            end
            FAN_ONLY: begin
                if (!fan_on) begin
                    if (mode && too_cold) next_state = HEATING;
                    else if (!mode && too_hot) next_state = COOLING;
                    else next_state = IDLE;
                end
                else next_state = FAN_ONLY;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        current_state <= next_state;
    end

    // Output logic
    assign heater = (current_state == HEATING);
    assign aircon = (current_state == COOLING);
    assign fan = (current_state == HEATING) || 
                (current_state == COOLING) || 
                (current_state == FAN_ONLY);

endmodule