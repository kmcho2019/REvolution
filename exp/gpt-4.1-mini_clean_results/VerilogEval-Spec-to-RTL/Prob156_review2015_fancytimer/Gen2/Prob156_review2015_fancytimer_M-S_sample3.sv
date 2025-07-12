module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    localparam [1:0]
        SEARCH        = 2'd0,
        SHIFT_DELAY   = 2'd1,
        COUNTING      = 2'd2,
        DONE_WAIT_ACK = 2'd3;

    localparam [3:0] PATTERN = 4'b1101;

    reg [1:0] state, next_state;

    reg [3:0] pattern_shift;
    reg [3:0] delay;
    reg [2:0] delay_bits_shifted;

    reg [9:0] cycle_counter;       // counts 0 to 999
    reg [4:0] delay_counter;       // counts number of 1000-cycle blocks left

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay <= 4'b0;
            delay_bits_shifted <= 3'd0;
            cycle_counter <= 10'd0;
            delay_counter <= 5'd0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data to detect pattern
                    pattern_shift <= {pattern_shift[2:0], data};

                    // outputs in idle
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;

                    // clear counters
                    delay_bits_shifted <= 3'd0;
                    cycle_counter <= 10'd0;
                    delay_counter <= 5'd0;
                    delay <= 4'b0;
                end

                SHIFT_DELAY: begin
                    // Shift in delay bits MSB first
                    // On each clock, shift delay left by 1 and append data LSB
                    delay <= {delay[2:0], data};
                    delay_bits_shifted <= delay_bits_shifted + 1'b1;

                    // outputs idle
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;

                    cycle_counter <= 10'd0;
                    delay_counter <= 5'd0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Increment cycle counter each clock
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (delay_counter != 0)
                            delay_counter <= delay_counter - 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // Output count = delay_counter - 1 (current remaining blocks)
                    // delay_counter counts blocks left including current one
                    if (delay_counter != 0)
                        count <= delay_counter - 1'b1;
                    else
                        count <= 4'd0;
                end

                DONE_WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;

                    // Hold counters and registers until ack
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_shift == PATTERN)
                    next_state = SHIFT_DELAY;
            end

            SHIFT_DELAY: begin
                if (delay_bits_shifted == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When finished counting all blocks
                if ((delay_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE_WAIT_ACK;
            end

            DONE_WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Initialize delay_counter on entering COUNTING state
    // To detect entering COUNTING, compare next_state and current state
    wire entering_counting = (state != COUNTING) && (next_state == COUNTING);

    always @(posedge clk) begin
        if (reset) begin
            // already reset above
        end else if (entering_counting) begin
            delay_counter <= {1'b0, delay} + 1'b1; // delay+1 blocks, 5 bits to avoid overflow
            cycle_counter <= 10'd0;
        end
    end

endmodule