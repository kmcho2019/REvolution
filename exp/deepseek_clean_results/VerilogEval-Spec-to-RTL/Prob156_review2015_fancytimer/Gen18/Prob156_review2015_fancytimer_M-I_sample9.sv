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
    reg [2:0] bit_counter;

    // Counting logic
    reg [9:0] cycle_counter;  // Counts 0-999 (1000 cycles)
    reg [3:0] phase_counter;  // Counts delay+1 phases
    reg ack_sync, ack_rise;

    // Output registers
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE, CAPTURE_DELAY: begin
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // Update count at phase boundaries
                    if (cycle_counter == 10'd999) begin
                        count <= phase_counter - 1;
                    end
                end
                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;
                end
            endcase
        end
    end

    // Synchronize ack signal and detect rising edge
    always @(posedge clk) begin
        ack_sync <= ack;
        ack_rise <= ack & ~ack_sync;
    end

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_counter <= 3'b0;
            cycle_counter <= 10'b0;
            phase_counter <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_match) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 3'b0;
                        pattern_reg <= 4'b0; // Clear pattern after detection
                    end
                end

                CAPTURE_DELAY: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3'd3) begin
                        state <= COUNTING;
                        cycle_counter <= 10'b0;
                        phase_counter <= delay_reg + 1;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        phase_counter <= phase_counter - 1;
                        if (phase_counter == 4'd1) begin
                            state <= DONE;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE: begin
                    if (ack_rise) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule