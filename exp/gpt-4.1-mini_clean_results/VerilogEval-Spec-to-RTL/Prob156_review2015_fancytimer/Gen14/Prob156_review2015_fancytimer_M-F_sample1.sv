module TopModule(
    input         clk,
    input         reset, // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // State encoding
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE_WAIT  = 2'd3;

    reg [1:0] state, next_state;

    // For pattern detection: shift in data MSB first
    reg [3:0] pattern_shift;

    // For loading delay bits MSB first
    reg [3:0] delay_reg;
    reg [2:0] load_count; // counts 0..4 bits loaded

    // Counting timers
    reg [9:0] cycle_counter; // counts 0..999 cycles
    reg [3:0] tick_counter;  // counts down from delay_reg to 0

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            load_count <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    load_count <= 3'd0;

                    // Shift in pattern MSB first: left shift, new data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;

                    // Shift in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    load_count <= load_count + 1'b1;

                    // pattern_shift hold or don't care here
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 4'd0)
                            tick_counter <= tick_counter - 1'b1;
                        // else remain at 0 (count done)
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // Output count is current tick_counter value
                    count <= tick_counter;
                end

                DONE_WAIT: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    load_count <= 3'd0;
                    // pattern_shift and delay_reg hold values but unused here
                end

                default: begin
                    // Defensive reset to SEARCH state
                    state <= SEARCH;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    load_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end
            endcase
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
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Transition to DONE_WAIT when tick_counter == 0 and cycle_counter == 999 (i.e. last cycle done)
                if ((tick_counter == 4'd0) && (cycle_counter == 10'd999))
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // On entering COUNTING state, initialize tick_counter to delay_reg and cycle_counter to 0
    always @(posedge clk) begin
        if (!reset) begin
            if (state != COUNTING && next_state == COUNTING) begin
                // Loading finished, start counting:
                tick_counter <= delay_reg; // set ticks to delay_reg value
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule