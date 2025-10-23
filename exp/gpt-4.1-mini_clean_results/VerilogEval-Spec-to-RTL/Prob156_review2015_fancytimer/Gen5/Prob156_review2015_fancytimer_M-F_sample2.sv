module TopModule (
    input        clk,
    input        reset,   // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // FSM States
    typedef enum reg [2:0] {
        IDLE    = 3'd0,
        DETECT  = 3'd1,
        LOAD    = 3'd2,
        COUNT   = 3'd3,
        WAIT_ACK= 3'd4
    } state_t;
    reg [2:0] state, next_state;

    // Shift registers and counters
    reg [3:0] pattern_shift;   // For pattern detection (MSB first)
    reg [3:0] delay_shift;     // For loading delay bits MSB first
    reg [2:0] load_bits;       // number of delay bits loaded (0..4)
    reg [9:0] period_count;    // counts 0..999 clock cycles per segment (10 bits for 1000)
    reg [3:0] remaining;       // counts down delay to 0

    // Next state logic (combinational)
    always @(*) begin
        next_state = state;
        case(state)
            IDLE:      next_state = DETECT;
            DETECT: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD;
            end
            LOAD: begin
                if (load_bits == 3'd4)
                    next_state = COUNT;
            end
            COUNT: begin
                // When period_count reaches 999 and remaining is 0, done counting
                if ((period_count == 10'd999) && (remaining == 4'd0))
                    next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack)
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'd0;
            delay_shift <= 4'd0;
            load_bits <= 3'd0;
            period_count <= 10'd0;
            remaining <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Initialize all for pattern detection
                    pattern_shift <= 4'd0;
                    delay_shift <= 4'd0;
                    load_bits <= 3'd0;
                    period_count <= 10'd0;
                    remaining <= 4'd0;
                    count <= 4'dx; // don't care
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                DETECT: begin
                    // Shift pattern MSB first: shift left, input data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Keep other registers unchanged
                    delay_shift <= delay_shift;
                    load_bits <= 3'd0;
                    period_count <= 10'd0;
                    remaining <= 4'd0;
                    count <= 4'dx;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD: begin
                    // Shift delay bits MSB first: shift left, input data at LSB
                    delay_shift <= {delay_shift[2:0], data};
                    load_bits <= load_bits + 1'b1;

                    // Hold pattern_shift (not needed but safe)
                    pattern_shift <= pattern_shift;
                    period_count <= 10'd0;
                    remaining <= 4'd0;
                    count <= 4'dx;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNT: begin
                    // Counting active
                    counting <= 1'b1;
                    done <= 1'b0;
                    pattern_shift <= pattern_shift;
                    delay_shift <= delay_shift;
                    load_bits <= load_bits;

                    // period_count counts 0..999
                    if (period_count == 10'd999) begin
                        period_count <= 10'd0;
                        // Decrement remaining only if not zero
                        if (remaining != 4'd0)
                            remaining <= remaining - 1'b1;
                        else
                            remaining <= 4'd0; // stays zero
                    end else begin
                        period_count <= period_count + 1'b1;
                        remaining <= remaining; // hold
                    end

                    // Output count = remaining (exactly)
                    count <= remaining;
                end

                WAIT_ACK: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'dx; // don't care
                    pattern_shift <= pattern_shift;
                    delay_shift <= delay_shift;
                    load_bits <= load_bits;
                    period_count <= 10'd0;
                    remaining <= 4'd0;
                end

                default: begin
                    state <= IDLE;
                    pattern_shift <= 4'd0;
                    delay_shift <= 4'd0;
                    load_bits <= 3'd0;
                    period_count <= 10'd0;
                    remaining <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // Load remaining from delay_shift at transition LOAD -> COUNT
            if ((state == LOAD) && (next_state == COUNT)) begin
                // Set remaining = delay_shift (no +1)
                // This makes counting show 'delay' first, then down to 0
                remaining <= delay_shift;
                period_count <= 10'd0;
            end
        end
    end

endmodule