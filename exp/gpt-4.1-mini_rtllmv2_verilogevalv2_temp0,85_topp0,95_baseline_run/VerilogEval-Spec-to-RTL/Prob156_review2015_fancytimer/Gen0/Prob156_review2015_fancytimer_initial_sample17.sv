module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    typedef enum reg [1:0] {
        SEARCH = 2'b00,
        READ_DELAY = 2'b01,
        COUNTING = 2'b10,
        DONE = 2'b11
    } state_t;

    reg [1:0] state, next_state;

    // Shift register for detecting pattern 1101
    reg [3:0] pattern_shift;

    // Shift register for reading delay bits
    reg [3:0] delay;
    reg [2:0] delay_bits_shifted; // counts how many bits shifted in READ_DELAY (0-3)

    // Counters for counting clock cycles and units
    reg [9:0] cycle_counter; // counts 0 to 999 for 1000 cycles
    reg [3:0] unit_counter;  // counts delay down to 0

    // Sequential state and data registers
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_shifted <= 3'd0;
            cycle_counter <= 10'd0;
            unit_counter <= 4'd0;
            count <= 4'b0000;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                SEARCH: begin
                    // Shift in data to pattern_shift
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care when not counting
                    delay_bits_shifted <= 3'd0;
                    cycle_counter <= 10'd0;
                    unit_counter <= 4'd0;
                    delay <= 4'b0000;
                end

                READ_DELAY: begin
                    // Shift in delay bits MSB first
                    delay <= {delay[2:0], data};
                    delay_bits_shifted <= delay_bits_shifted + 1'b1;
                    // Outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0000; // don't care when not counting
                    cycle_counter <= 10'd0;
                    unit_counter <= 4'd0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= unit_counter;
                    // Cycle counter increments each clock cycle
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (unit_counter != 4'd0)
                            unit_counter <= unit_counter - 1'b1;
                        else
                            unit_counter <= unit_counter; // remain 0
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0000; // don't care when done
                    cycle_counter <= 10'd0;
                    unit_counter <= 4'd0;
                    delay_bits_shifted <= 3'd0;
                    delay <= 4'b0000;
                    pattern_shift <= 4'b0000;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Detect 1101 pattern
                // pattern_shift after shifting in new bit holds last 4 bits; check if equals 1101b (binary 13 decimal)
                if (pattern_shift == 4'b1101) 
                    next_state = READ_DELAY;
                else
                    next_state = SEARCH;
            end

            READ_DELAY: begin
                // After reading 4 delay bits, go to COUNTING
                if (delay_bits_shifted == 3'd4)
                    next_state = COUNTING;
                else
                    next_state = READ_DELAY;
            end

            COUNTING: begin
                // Count until (delay+1)*1000 cycles finished
                // That means unit_counter counts down from delay to 0, each with 1000 cycles counted by cycle_counter
                if ((unit_counter == 4'd0) && (cycle_counter == 10'd999))
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end

            DONE: begin
                // Wait for ack to return to SEARCH
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize delay_bits_shifted to 0 on entering READ_DELAY state
    // We already reset delay_bits_shifted on SEARCH and DONE states

endmodule