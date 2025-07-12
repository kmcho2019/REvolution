module TopModule (
    input  wire clk,
    input  wire reset,            // synchronous active high reset
    input  wire pattern_detected, // external pattern detection signal, 1 cycle pulse
    output reg  shift_ena
);

    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        ENABLE = 2'b01
    } state_t;

    state_t state, next_state;
    reg [2:0] enable_counter; // enough bits to count to 4

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= ENABLE;
            enable_counter <= 3'd4;  // start 4-cycle enable on reset
        end else begin
            state <= next_state;
            if (state == ENABLE) begin
                if (enable_counter != 0)
                    enable_counter <= enable_counter - 3'd1;
            end else if (pattern_detected) begin
                enable_counter <= 3'd4; // restart counter on pattern detection
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (pattern_detected)
                    next_state = ENABLE;
                else
                    next_state = IDLE;
            end

            ENABLE: begin
                if (enable_counter == 0)
                    next_state = IDLE;
                else
                    next_state = ENABLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1'b1; // asserted immediately on reset
        end else begin
            shift_ena <= (state == ENABLE);
        end
    end

endmodule