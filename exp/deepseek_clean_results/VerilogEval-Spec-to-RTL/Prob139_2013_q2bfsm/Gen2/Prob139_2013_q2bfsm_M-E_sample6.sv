module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // Main state machine states
    typedef enum {
        INIT,
        OPERATIONAL
    } main_state_t;

    // Pattern detection states
    typedef enum {
        WAIT_FOR_1,
        WAIT_FOR_0,
        WAIT_FOR_1_AGAIN
    } pattern_state_t;

    main_state_t current_state;
    pattern_state_t pattern_state;
    
    // Control flags
    reg f_pulse_sent;
    reg pattern_matched;
    reg y_monitor_active;
    reg [1:0] y_timeout;
    reg y_detected;

    // 3-bit shift register for pattern detection
    reg [2:0] x_shift;

    always @(posedge clk) begin
        if (!resetn) begin
            // Reset all states and registers
            current_state <= INIT;
            pattern_state <= WAIT_FOR_1;
            f_pulse_sent <= 0;
            pattern_matched <= 0;
            y_monitor_active <= 0;
            y_timeout <= 0;
            y_detected <= 0;
            x_shift <= 0;
            f <= 0;
            g <= 0;
        end else begin
            // Update shift register
            x_shift <= {x_shift[1:0], x};

            case (current_state)
                INIT: begin
                    if (!f_pulse_sent) begin
                        f <= 1;
                        f_pulse_sent <= 1;
                    end else begin
                        f <= 0;
                        current_state <= OPERATIONAL;
                    end
                end

                OPERATIONAL: begin
                    f <= 0;
                    
                    // Pattern detection state machine
                    case (pattern_state)
                        WAIT_FOR_1: begin
                            if (x) pattern_state <= WAIT_FOR_0;
                        end
                        WAIT_FOR_0: begin
                            if (!x) pattern_state <= WAIT_FOR_1_AGAIN;
                            else pattern_state <= WAIT_FOR_0;
                        end
                        WAIT_FOR_1_AGAIN: begin
                            if (x) begin
                                pattern_matched <= 1;
                                y_monitor_active <= 1;
                                y_timeout <= 0;
                                y_detected <= 0;
                            end
                            pattern_state <= WAIT_FOR_1;
                        end
                    endcase

                    // Y monitoring logic
                    if (y_monitor_active) begin
                        if (y) begin
                            y_detected <= 1;
                            y_monitor_active <= 0;
                        end else if (y_timeout == 2'b01) begin
                            y_monitor_active <= 0;
                        end else begin
                            y_timeout <= y_timeout + 1;
                        end
                    end

                    // Output g generation
                    if (pattern_matched) begin
                        if (y_detected || y_timeout < 2'b01)
                            g <= 1;
                        else
                            g <= 0;
                    end
                end
            endcase
        end
    end

endmodule