module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    typedef enum {
        SEARCH,      // Looking for 1101 pattern
        GET_DELAY,   // Capturing delay value
        TIMING,      // Counting down
        COMPLETE     // Done counting, waiting for ack
    } state_t;

    state_t state;
    reg [3:0] pattern_reg;  // Last 4 received bits
    reg [2:0] bit_count;    // Tracks bits received in current phase
    reg [3:0] delay_val;
    reg [9:0] sub_counter;  // Counts 0-999
    reg [13:0] main_counter; // Handles up to 16*1000 cycles

    // Parallel pattern detection
    wire pattern_match = (pattern_reg == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_reg <= 4'b0;
            bit_count <= 0;
            delay_val <= 0;
            sub_counter <= 0;
            main_counter <= 0;
            counting <= 0;
            done <= 0;
            count <= 0;
        end else begin
            // Shift in new data bit
            pattern_reg <= {pattern_reg[2:0], data};

            case (state)
                SEARCH: begin
                    if (pattern_match) begin
                        state <= GET_DELAY;
                        bit_count <= 0;
                    end
                    counting <= 0;
                    done <= 0;
                end

                GET_DELAY: begin
                    bit_count <= bit_count + 1;
                    if (bit_count == 3) begin
                        delay_val <= pattern_reg;
                        main_counter <= {pattern_reg, 10'b0} + 14'd1000;
                        sub_counter <= 0;
                        state <= TIMING;
                    end
                end

                TIMING: begin
                    counting <= 1;
                    if (sub_counter == 10'd999) begin
                        sub_counter <= 0;
                        main_counter <= main_counter - 14'd1000;
                        count <= main_counter[13:10] - 1;
                    end else begin
                        sub_counter <= sub_counter + 1;
                    end

                    if (main_counter == 14'd1000) begin
                        state <= COMPLETE;
                        counting <= 0;
                        done <= 1;
                    end
                end

                COMPLETE: begin
                    if (ack) begin
                        state <= SEARCH;
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule