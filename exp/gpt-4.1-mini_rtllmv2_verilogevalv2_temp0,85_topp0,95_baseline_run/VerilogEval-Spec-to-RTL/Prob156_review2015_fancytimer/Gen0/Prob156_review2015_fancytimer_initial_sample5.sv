module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  wire ack
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE       = 2'b00,
        READ_DELAY = 2'b01,
        COUNT      = 2'b10,
        DONE       = 2'b11
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection
    reg [3:0] pattern_reg;

    // Delay register for timer duration
    reg [3:0] delay;

    // Bit counter for READ_DELAY state (counts 0 to 3)
    reg [2:0] bit_cnt;

    // 10-bit cycle counter counts clock cycles 0 to 999
    reg [9:0] cycle_cnt;

    // Remaining delay count used during COUNT state
    reg [3:0] delay_count;

    // Sequential logic for state transitions and registers
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers and outputs
            state       <= IDLE;
            pattern_reg <= 4'b0000;
            delay       <= 4'b0000;
            bit_cnt     <= 3'd0;
            cycle_cnt   <= 10'd0;
            delay_count <= 4'd0;
            counting    <= 1'b0;
            done        <= 1'b0;
            count       <= 4'b0000;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Shift in data for pattern detection
                    pattern_reg <= {pattern_reg[2:0], data};
                    // outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                READ_DELAY: begin
                    // Shift in delay bits MSB first
                    delay <= {delay[2:0], data};
                    bit_cnt <= bit_cnt + 1'b1;
                    // outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= delay_count;

                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        if (delay_count != 0)
                            delay_count <= delay_count - 1'b1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000;
                    // Hold all registers stable (no updates)
                end

                default: begin
                    // Should not occur, reset outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                // Detect pattern 1101 on pattern_reg after shifting in new bit
                // pattern_reg updated after posedge clk, so check current value
                if (pattern_reg == 4'b1101)
                    next_state = READ_DELAY;
            end

            READ_DELAY: begin
                // After reading 4 delay bits, go to COUNT state
                if (bit_cnt == 3'd3)
                    next_state = COUNT;
            end

            COUNT: begin
                // Count down to 0 and cycle_cnt to 999 means counting done
                if ((delay_count == 0) && (cycle_cnt == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack to return to IDLE
                if (ack == 1'b1)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Additional logic to initialize counters and registers on transitions

    // Initialize delay and counters on READ_DELAY start and COUNT start
    always @(posedge clk) begin
        if (reset) begin
            bit_cnt <= 3'd0;
            cycle_cnt <= 10'd0;
            delay_count <= 4'd0;
        end else begin
            if (state == IDLE && next_state == READ_DELAY) begin
                // Start reading delay bits
                bit_cnt <= 3'd0;
                delay <= 4'b0000;
            end

            if (state == READ_DELAY && next_state == COUNT) begin
                // Initialize counters for COUNT state
                cycle_cnt <= 10'd0;
                delay_count <= delay;
            end

            if (state == DONE && next_state == IDLE) begin
                // Clear pattern register to start fresh search
                pattern_reg <= 4'b0000;
            end
        end
    end

endmodule