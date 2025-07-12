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
    reg [3:0] pattern_shift;   // For pattern detection
    reg [3:0] delay_shift;     // For loading delay bits MSB first
    reg [2:0] load_bits;       // number of delay bits loaded (0..4)
    reg [15:0] cycle_count;    // counts 0..999 cycles
    reg [3:0] remaining;       // counts down delay+1 to 0

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: next_state = DETECT;
            DETECT: 
                if (pattern_shift == 4'b1101)
                    next_state = LOAD;
            LOAD:
                if (load_bits == 3'd4)
                    next_state = COUNT;
            COUNT:
                if (remaining == 4'd0 && cycle_count == 16'd999)
                    next_state = WAIT_ACK;
            WAIT_ACK:
                if (ack)
                    next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'd0;
            delay_shift <= 4'd0;
            load_bits <= 3'd0;
            cycle_count <= 16'd0;
            remaining <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Reset pattern shift and all counters
                    pattern_shift <= 4'd0;
                    delay_shift <= 4'd0;
                    load_bits <= 3'd0;
                    cycle_count <= 16'd0;
                    remaining <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                DETECT: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'd0;
                    // Shift pattern in LSB: shift left, insert data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_shift <= delay_shift; // Hold delay_shift
                    load_bits <= 3'd0;
                    cycle_count <= 16'd0;
                    remaining <= 4'd0;
                end

                LOAD: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'd0;
                    pattern_shift <= pattern_shift; // Hold pattern

                    // Shift in delay MSB first: shift right, insert new bit at MSB
                    // delay_shift[3] <= data, delay_shift[2:0] <= delay_shift[3:1]
                    delay_shift <= {data, delay_shift[3:1]};
                    load_bits <= load_bits + 1;
                end

                COUNT: begin
                    done <= 1'b0;
                    counting <= 1'b1;
                    pattern_shift <= pattern_shift;  // hold
                    delay_shift <= delay_shift;
                    load_bits <= load_bits;

                    if (cycle_count == 16'd999) begin
                        cycle_count <= 16'd0;
                        if (remaining != 4'd0)
                            remaining <= remaining - 1;
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end

                    // Output count = remaining - 1 during counting (0 for remaining=0)
                    if (remaining != 0)
                        count <= remaining - 1;
                    else
                        count <= 4'd0;
                end

                WAIT_ACK: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;
                    pattern_shift <= pattern_shift;
                    delay_shift <= delay_shift;
                    load_bits <= load_bits;
                    cycle_count <= 16'd0;
                    remaining <= 4'd0;
                end

                default: begin
                    state <= IDLE;
                    pattern_shift <= 4'd0;
                    delay_shift <= 4'd0;
                    load_bits <= 3'd0;
                    cycle_count <= 16'd0;
                    remaining <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // Initialize remaining when transitioning from LOAD to COUNT
            if (state == LOAD && next_state == COUNT) begin
                // delay_shift holds delay bits (correct MSB first)
                // Timer counts (delay + 1) * 1000 cycles
                remaining <= delay_shift + 1;
                cycle_count <= 16'd0;
            end
        end
    end

endmodule