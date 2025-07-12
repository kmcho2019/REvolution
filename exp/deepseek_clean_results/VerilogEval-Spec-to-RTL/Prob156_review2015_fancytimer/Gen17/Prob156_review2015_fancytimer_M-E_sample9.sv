module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        CAPTURE_DELAY,
        COUNTING,
        DONE
    } state_t;

    state_t state, next_state;

    // Pattern detection
    reg [3:0] pattern_reg;
    wire pattern_match = (pattern_reg == 4'b1101);

    // Delay capture
    reg [3:0] delay_reg;
    reg [2:0] bit_counter;

    // Counting logic
    reg [15:0] cycle_counter;
    wire [15:0] max_cycles = (delay_reg + 1) * 16'd1000;
    reg ack_sync;

    // Pre-computed count values
    always @* begin
        if (state == COUNTING) begin
            count = (max_cycles - cycle_counter - 1) / 16'd1000;
        end else begin
            count = 4'b0; // Don't-care when not counting
        end
    end

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_counter <= 3'b0;
            cycle_counter <= 16'b0;
            counting <= 1'b0;
            done <= 1'b0;
            ack_sync <= 1'b0;
        end else begin
            // Synchronize ack signal
            ack_sync <= ack;

            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_match) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 3'b0;
                    end
                end

                CAPTURE_DELAY: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3'd3) begin
                        state <= COUNTING;
                        cycle_counter <= 16'b0;
                        counting <= 1'b1;
                    end
                end

                COUNTING: begin
                    cycle_counter <= cycle_counter + 1;
                    if (cycle_counter + 1 == max_cycles) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end

                DONE: begin
                    if (ack_sync) begin
                        state <= IDLE;
                        done <= 1'b0;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule