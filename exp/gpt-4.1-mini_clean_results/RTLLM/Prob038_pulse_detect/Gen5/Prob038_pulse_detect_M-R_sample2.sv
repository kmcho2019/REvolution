module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    // Binary encoded states
    typedef enum logic [1:0] {
        IDLE         = 2'b00,
        HIGH_DETECTED = 2'b01,
        LOW_WAIT     = 2'b10,
        PULSE_END    = 2'b11
    } state_t;

    state_t state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH_DETECTED;
                else
                    next_state = IDLE;
            end
            HIGH_DETECTED: begin
                if (!data_in)
                    next_state = LOW_WAIT;
                else
                    next_state = HIGH_DETECTED;
            end
            LOW_WAIT: begin
                if (!data_in)
                    next_state = PULSE_END;
                else
                    next_state = HIGH_DETECTED;
            end
            PULSE_END: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output is combinational, high only when in PULSE_END state
    assign data_out = (state == PULSE_END);

endmodule