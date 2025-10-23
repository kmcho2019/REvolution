module TopModule (
    input        clk,
    input        reset,  // synchronous active-high reset
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // States encoding
    localparam IDLE       = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection
    reg [3:0] pattern_shift;

    // Delay register and bit count for LOAD_DELAY
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded;

    // Counting timers
    reg [9:0] cycle_counter; // 0..999
    reg [3:0] tick_counter;  // delay down to 0

    // Pattern match
    wire pattern_found = (pattern_shift == 4'b1101);

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE:
                if(pattern_found)
                    next_state = LOAD_DELAY;
            LOAD_DELAY:
                if(delay_bits_loaded == 4)
                    next_state = COUNTING;
            COUNTING:
                if(tick_counter == 0 && cycle_counter == 10'd999)
                    next_state = DONE;
            DONE:
                if(ack)
                    next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Shift in pattern bits for detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift delay bits MSB first (shift left, input at LSB)
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    pattern_shift <= pattern_shift; // hold pattern shift
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNTING: begin
                    pattern_shift <= pattern_shift; // hold pattern shift
                    done <= 1'b0;
                    counting <= 1'b1;
                    count <= tick_counter;

                    if(cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if(tick_counter != 0)
                            tick_counter <= tick_counter - 1'b1;
                    end else
                        cycle_counter <= cycle_counter + 1'b1;
                end

                DONE: begin
                    pattern_shift <= pattern_shift;
                    delay_bits_loaded <= delay_bits_loaded;
                    delay_reg <= delay_reg;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0; // don't care
                end

                default: begin
                    // safety fallback
                    state <= IDLE;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // On transition from LOAD_DELAY to COUNTING: initialize tick_counter and cycle_counter
            if(state == LOAD_DELAY && next_state == COUNTING) begin
                tick_counter <= delay_reg;  // start counting with delay value
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule