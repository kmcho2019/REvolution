module TopModule (
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    // Define states
    localparam IDLE     = 2'b00;
    localparam HEATING  = 2'b01;
    localparam COOLING  = 2'b10;
    localparam FAN_ONLY = 2'b11;

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
                if (!mode || !too_cold) begin
                    if (fan_on) next_state = FAN_ONLY;
                    else next_state = IDLE;
                end
                else next_state = HEATING;
            end
            COOLING: begin
                if (mode || !too_hot) begin
                    if (fan_on) next_state = FAN_ONLY;
                    else next_state = IDLE;
                end
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

    // Output logic
    always @(*) begin
        case (current_state)
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
            FAN_ONLY: begin
                heater = 1'b0;
                aircon = 1'b0;
                fan = 1'b1;
            end
            default: begin  // IDLE
                heater = 1'b0;
                aircon = 1'b0;
                fan = 1'b0;
            end
        endcase
    end

    // State register
    always @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        current_state <= next_state;
    end

endmodule