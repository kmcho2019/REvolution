module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam RING    = 2'b01;
    localparam VIBRATE = 2'b10;

    reg [1:0] state, next_state;
    reg [1:0] mode_switch_delay;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (ring) begin
                    next_state = vibrate_mode ? VIBRATE : RING;
                end else begin
                    next_state = IDLE;
                end
            end
            RING: begin
                if (!ring) begin
                    next_state = IDLE;
                end else if (vibrate_mode && mode_switch_delay == 0) begin
                    next_state = VIBRATE;
                end else begin
                    next_state = RING;
                end
            end
            VIBRATE: begin
                if (!ring) begin
                    next_state = IDLE;
                end else if (!vibrate_mode && mode_switch_delay == 0) begin
                    next_state = RING;
                end else begin
                    next_state = VIBRATE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Mode switch delay counter
    always @(posedge ring or posedge vibrate_mode) begin
        if (state == RING || state == VIBRATE) begin
            mode_switch_delay <= 2'b11; // 2 cycle delay
        end else begin
            mode_switch_delay <= 2'b00;
        end
    end

    always @(posedge ring) begin
        if (mode_switch_delay > 0) begin
            mode_switch_delay <= mode_switch_delay - 1;
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            IDLE:    {ringer, motor} = 2'b00;
            RING:    {ringer, motor} = 2'b10;
            VIBRATE: {ringer, motor} = 2'b01;
            default: {ringer, motor} = 2'b00;
        endcase
    end

    // State register
    always @(posedge ring) begin
        state <= next_state;
    end

endmodule