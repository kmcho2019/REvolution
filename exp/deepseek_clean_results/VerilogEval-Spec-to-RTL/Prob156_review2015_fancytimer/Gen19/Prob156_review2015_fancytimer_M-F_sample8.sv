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
    typedef enum logic [2:0] {
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
    reg [1:0] bit_counter;

    // Counting logic
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] remaining_phases;
    wire phase_done = (cycle_counter == 10'd999);

    // Synchronize ack
    reg ack_sync, ack_rise;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_counter <= 2'b0;
            cycle_counter <= 10'b0;
            remaining_phases <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
            ack_sync <= 1'b0;
            ack_rise <= 1'b0;
        end else begin
            // Synchronize and detect rising edge of ack
            ack_sync <= ack;
            ack_rise <= ~ack_sync & ack;

            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_match) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 2'b0;
                    end
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                CAPTURE_DELAY: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 2'd3) begin
                        state <= COUNTING;
                        cycle_counter <= 10'b0;
                        remaining_phases <= {delay_reg[2:0], data}; // Capture final bit
                        counting <= 1'b1;
                    end
                end

                COUNTING: begin
                    count <= remaining_phases;
                    if (phase_done) begin
                        cycle_counter <= 10'b0;
                        if (remaining_phases == 4'b0) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            remaining_phases <= remaining_phases - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE: begin
                    if (ack_rise) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0; // Clear pattern only when returning to IDLE
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule