module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg       counting,
    output reg       done,
    input        ack
);

    // States
    localparam SEARCH      = 2'd0;
    localparam LOAD_DELAY  = 2'd1;
    localparam COUNT       = 2'd2;
    localparam WAIT_ACK    = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] pattern_shift;     // For pattern detection (MSB first)
    reg [3:0] delay_shift;       // For delay bits loading (MSB first)
    reg [2:0] delay_bit_count;   // counts 0..4 delay bits loaded

    reg [3:0] delay_value;       // latched delay value after loading

    reg [9:0] cycle_counter;     // counts 0..999 cycles
    reg [4:0] tick_counter;      // counts down from delay+1 to 0

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_shift <= 4'b0000;
            delay_bit_count <= 3'd0;
            delay_value <= 4'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in new bit at MSB (MSB first input):
                    pattern_shift <= {data, pattern_shift[3:1]};
                    // Clear delay-related registers
                    delay_shift <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    delay_value <= delay_value; // hold until LOAD_DELAY latches
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first
                    delay_shift <= {data, delay_shift[3:1]};
                    delay_bit_count <= delay_bit_count + 1'b1;
                    pattern_shift <= pattern_shift; // hold pattern to avoid accidental changes
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    // Latch delay_value exactly when delay_bit_count reaches 3 (4th bit)
                    if (delay_bit_count == 3'd3) begin
                        // delay_shift still has previous bits, data is newest MSB bit
                        delay_value <= {data, delay_shift[3:1]};
                    end
                end

                COUNT: begin
                    pattern_shift <= pattern_shift; // hold pattern stable
                    delay_shift <= delay_shift;     // hold delay_shift stable
                    delay_bit_count <= delay_bit_count;
                    delay_value <= delay_value;

                    done <= 1'b0;
                    counting <= 1'b1;

                    // Increment cycle counter
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        // Decrement tick_counter if > 0
                        if (tick_counter != 0)
                            tick_counter <= tick_counter - 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                        tick_counter <= tick_counter;
                    end

                    // Update count output to show current tick_counter - 1
                    // When tick_counter==0, count will underflow so clamp to 0
                    if (tick_counter == 0)
                        count <= 4'd0;
                    else
                        count <= tick_counter - 1'b1;
                end

                WAIT_ACK: begin
                    // Hold done asserted until ack received
                    done <= 1'b1;
                    counting <= 1'b0;
                    // Clear registers for next search after ack
                    pattern_shift <= 4'b0000;
                    delay_shift <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    delay_value <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    count <= 4'd0;
                end

                default: begin
                    // Safe reset state
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay_shift <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    delay_value <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // Initialize counters when entering COUNT state (on rising edge of clk)
            if (state != COUNT && next_state == COUNT) begin
                cycle_counter <= 10'd0;
                tick_counter <= delay_value + 1'b1; // count (delay+1) intervals
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (delay_bit_count == 3'd4)
                    next_state = COUNT;
            end

            COUNT: begin
                // Finished counting when tick_counter == 0 and last 1000 cycles done (cycle_counter==999)
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = WAIT_ACK;
            end

            WAIT_ACK: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

endmodule