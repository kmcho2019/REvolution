module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE        = 2'd0,
        HIGH_DETECTED = 2'd1,
        LOW_WAIT    = 2'd2,
        PULSE_END   = 2'd3
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = HIGH_DETECTED;
                else
                    next_state = IDLE;
            end
            HIGH_DETECTED: begin
                if (data_in == 1'b0)
                    next_state = LOW_WAIT;
                else
                    next_state = HIGH_DETECTED;
            end
            LOW_WAIT: begin
                if (data_in == 1'b0)
                    next_state = PULSE_END;
                else
                    // If data_in goes back to 1 again before ending low, restart counting
                    next_state = HIGH_DETECTED;
            end
            PULSE_END: begin
                // After pulse end is signaled, go back to IDLE
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State and output register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Assert data_out only in PULSE_END state for one cycle
            data_out <= (next_state == PULSE_END);
        end
    end

endmodule