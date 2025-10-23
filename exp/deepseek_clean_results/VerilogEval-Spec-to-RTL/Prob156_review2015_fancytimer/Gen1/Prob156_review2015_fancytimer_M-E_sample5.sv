module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    typedef enum logic [1:0] {
        SEARCH,
        CAPTURE,
        TIMING,
        COMPLETE
    } state_t;

    state_t current_state, next_state;

    // Pattern detection
    reg [3:0] data_history;
    wire pattern_match = (data_history == 4'b1101);

    // Delay capture
    reg [3:0] delay_value;
    reg [1:0] bit_counter;

    // Timing counters
    reg [9:0] cycle_counter;  // 0-999 (1000 cycles)
    reg [3:0] delay_counter;  // Current delay count

    // State machine
    always @(posedge clk) begin
        if (reset) begin
            current_state <= SEARCH;
            data_history <= 4'b0;
            delay_value <= 4'b0;
            bit_counter <= 2'b0;
            cycle_counter <= 10'b0;
            delay_counter <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            current_state <= next_state;

            // Common operations
            data_history <= {data_history[2:0], data};

            case (current_state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (pattern_match) begin
                        bit_counter <= 2'b0;
                    end
                end

                CAPTURE: begin
                    if (bit_counter < 3) begin
                        delay_value <= {delay_value[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end else begin
                        delay_value[0] <= data;  // Final bit
                        delay_counter <= {delay_value[2:0], data};
                        cycle_counter <= 10'b0;
                    end
                end

                TIMING: begin
                    counting <= 1'b1;
                    if (cycle_counter == 999) begin
                        cycle_counter <= 10'b0;
                        if (delay_counter == 0) begin
                            next_state <= COMPLETE;
                        end else begin
                            delay_counter <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    count <= delay_counter;
                end

                COMPLETE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack) begin
                        next_state <= SEARCH;
                        data_history <= 4'b0;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            SEARCH: next_state = pattern_match ? CAPTURE : SEARCH;
            CAPTURE: next_state = (bit_counter == 3) ? TIMING : CAPTURE;
            TIMING: next_state = (delay_counter == 0 && cycle_counter == 999) ? COMPLETE : TIMING;
            COMPLETE: next_state = ack ? SEARCH : COMPLETE;
            default: next_state = SEARCH;
        endcase
    end

endmodule