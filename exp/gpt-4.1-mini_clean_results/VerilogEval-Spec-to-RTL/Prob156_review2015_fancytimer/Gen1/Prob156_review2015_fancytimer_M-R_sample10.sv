module TopModule (
    input clk,
    input reset,  // synchronous active high
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States for FSM
    typedef enum reg [1:0] {
        SEARCH = 2'b00,
        LOAD_DELAY = 2'b01,
        COUNTING = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register, only updated in SEARCH
    reg [3:0] pattern_shift;

    // Delay register to hold shifted-in delay bits
    reg [3:0] delay;

    // Count of how many delay bits loaded so far in LOAD_DELAY
    reg [2:0] delay_bits_loaded; // 0..4

    // Total cycle countdown: counts from (delay+1)*1000 -1 down to 0 (13 bits to count up to 16,000)
    reg [13:0] total_cycle; 

    // Next state logic (combinational)
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (delay_bits_loaded == 4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                if (total_cycle == 0)
                    next_state = DONE;
            end
            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic: state update and outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_loaded <= 0;
            total_cycle <= 0;
            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'b0000; // don't-care, output zero here

                    // Shift pattern_shift left and input data bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Reset delay loading
                    delay_bits_loaded <= 0;
                    delay <= 4'b0000;
                    total_cycle <= 0;
                end

                LOAD_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'b0000; // don't-care

                    // Shift in delay bits MSB first:
                    // shift left one bit, input data at LSB
                    delay <= {delay[2:0], data};

                    // Increment delay bits loaded
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    if (total_cycle > 0) begin
                        total_cycle <= total_cycle - 1'b1;
                    end else begin
                        total_cycle <= 0; // stays at 0
                    end

                    // Calculate count = total_cycle / 1000
                    // total_cycle max 16000, division by 1000 fits in 4 bits
                    count <= total_cycle / 10'd1000;
                end

                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'b0000; // don't-care

                    // Clear pattern_shift and delay after ack (handled below)
                end
            endcase

            // On transition from LOAD_DELAY to COUNTING, initialize total_cycle
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                // (delay + 1) * 1000 - 1 to count down
                total_cycle <= (({10'b0, delay} + 1) * 1000) - 1;
                count <= delay;
            end

            // On transition from DONE to SEARCH, clear internal registers for next round
            if (state == DONE && next_state == SEARCH) begin
                pattern_shift <= 4'b0000;
                delay <= 4'b0000;
                delay_bits_loaded <= 0;
                total_cycle <= 0;
                count <= 4'b0000;
                done <= 1'b0;
                counting <= 1'b0;
            end
        end
    end

endmodule