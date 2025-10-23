module TopModule (
    input        clk,
    input        reset,   // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // States definition
    localparam SEARCH      = 3'd0;
    localparam LOAD_DELAY  = 3'd1;
    localparam COUNTING    = 3'd2;
    localparam DONE        = 3'd3;

    reg [2:0] state, next_state;

    // Shift register to detect pattern 1101 on 'data' during SEARCH
    reg [3:0] pattern_shift;

    // Delay register loaded from serial bits (MSB first)
    reg [3:0] delay_reg;

    // Bit counter for loading delay bits (0 to 3)
    reg [2:0] load_bit_count;

    // Cycle counter for 1000 clock cycles (0 to 999)
    reg [9:0] cycle_counter;

    // Delay units counter (counts down from delay_reg to 0)
    reg [3:0] delay_counter;

    // Sequential logic - state, counters, outputs
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'd0;
            load_bit_count <= 3'd0;
            cycle_counter <= 10'd0;
            delay_counter <= 4'd0;

            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data bit to detect pattern 1101
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Outputs inactive in SEARCH
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    // Clear counters used later
                    load_bit_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    delay_counter <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift delay_reg left, input bit at LSB to load MSB first
                    // E.g. delay_reg = {delay_reg[2:0], data}
                    delay_reg <= {delay_reg[2:0], data};
                    load_bit_count <= load_bit_count + 1;

                    // Outputs inactive in LOAD_DELAY
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Count cycles from 0 to 999 (1000 cycles)
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        // Decrement delay_counter if not zero
                        if (delay_counter != 0)
                            delay_counter <= delay_counter - 1;
                        // else remain zero
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end

                    // Output current delay_counter as count
                    count <= delay_counter;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;

                    // Wait here until ack == 1, no other state variables change
                end

                default: begin
                    // Default fallback state (should not occur)
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'd0;
                    load_bit_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    delay_counter <= 4'd0;

                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;

        case (state)
            SEARCH: begin
                // If pattern_shift matches 1101, start loading delay bits
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // When 4 bits loaded, move to COUNTING
                if (load_bit_count == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When delay_counter == 0 and cycle_counter == 999, counting done
                if ((delay_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack to return to SEARCH
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Load delay_counter and reset cycle_counter on transition to COUNTING
    // Use a register to detect state changes
    reg [2:0] state_dly;

    always @(posedge clk) begin
        if (reset)
            state_dly <= SEARCH;
        else
            state_dly <= state;
    end

    always @(posedge clk) begin
        if (!reset) begin
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                delay_counter <= delay_reg;
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule