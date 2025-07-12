module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // Pattern detection
    reg [3:0] data_history;
    wire pattern_match = (data_history == 4'b1101);

    // Timer counter (needs to handle up to 16*1000 = 16000 cycles)
    reg [13:0] timer_counter;  // 14 bits for 0-15999
    wire timer_expired = (timer_counter == 0);

    // Control FSM
    typedef enum {SEARCH, CAPTURE, RUN, COMPLETE} state_t;
    state_t state;

    // Delay value capture
    reg [3:0] delay_value;
    reg [1:0] capture_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            data_history <= 4'b0;
            timer_counter <= 0;
            delay_value <= 0;
            capture_count <= 0;
            done <= 0;
        end else begin
            // Shift in new data for pattern matching
            data_history <= {data_history[2:0], data};

            case (state)
                SEARCH: begin
                    if (pattern_match) begin
                        state <= CAPTURE;
                        capture_count <= 0;
                    end
                end

                CAPTURE: begin
                    delay_value <= {delay_value[2:0], data};
                    capture_count <= capture_count + 1;
                    if (capture_count == 3) begin
                        // Preload counter with (delay+1)*1000 - 1
                        timer_counter <= (delay_value * 1000) + 999;
                        state <= RUN;
                    end
                end

                RUN: begin
                    if (!timer_expired) begin
                        timer_counter <= timer_counter - 1;
                    end else begin
                        state <= COMPLETE;
                    end
                end

                COMPLETE: begin
                    if (ack) begin
                        state <= SEARCH;
                    end
                end
            endcase

            // Output done signal
            done <= (state == COMPLETE);
        end
    end

    // Output logic
    always @(*) begin
        counting = (state == RUN);
        // Calculate current period (count value)
        if (state == RUN) begin
            count = timer_counter / 1000;
        end else begin
            count = 4'b0; // Don't care when not counting
        end
    end

endmodule