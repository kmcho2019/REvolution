module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // States encoded as parameters
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam WAIT_ACK   = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] pattern_shift;
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // 0 to 4

    reg [9:0] cycle_counter;     // counts 0..999
    reg [3:0] tick_counter;      // counts down delay to 0

    localparam [3:0] START_PATTERN = 4'b1101;

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            delay_bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift pattern register: MSB-first means shift left, new bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_loaded <= 3'd0;
                    delay_reg <= 4'b0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB-first similarly
                    pattern_shift <= pattern_shift; // hold pattern_shift unchanged
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                COUNT: begin
                    pattern_shift <= pattern_shift; // no pattern shifting during count
                    delay_bits_loaded <= delay_bits_loaded;
                    delay_reg <= delay_reg;

                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 0)
                            tick_counter <= tick_counter - 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        tick_counter <= tick_counter;
                    end

                    count <= tick_counter;
                end

                WAIT_ACK: begin
                    // Wait for user ack, outputs done=1
                    pattern_shift <= pattern_shift; 
                    delay_bits_loaded <= delay_bits_loaded;
                    delay_reg <= delay_reg;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;
                end

                default: begin
                    state <= SEARCH;
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    delay_bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_shift == START_PATTERN)
                    next_state = LOAD_DELAY;
                else
                    next_state = SEARCH;
            end

            LOAD_DELAY: begin
                if (delay_bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;
            end

            COUNT: begin
                // Count done when tick_counter == 0 and cycle_counter == 999
                if (tick_counter == 0 && cycle_counter == 10'd999)
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            end

            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize counters when entering COUNT state
    always @(posedge clk) begin
        if (reset) begin
            // already handled
        end else if (state != COUNT && next_state == COUNT) begin
            tick_counter <= delay_reg + 1'b1; // delay + 1 ticks
            cycle_counter <= 10'd0;
            count <= delay_reg + 1'b1;
        end
    end

endmodule