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

    // For pattern detection: shift in data MSB first (new bit at MSB, shift right)
    reg [3:0] pattern_shift;

    // For loading delay bits MSB first (new bit at MSB, shift right)
    reg [3:0] delay_reg;
    reg [2:0] load_count; // counts bits loaded: 0..4

    // Counting timers
    reg [9:0] cycle_counter; // counts 0..999 cycles (1000 cycles)
    reg [4:0] tick_counter;  // counts down from delay_reg+1 to 0; 5 bits to hold max 17 ticks (15+1)

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            load_count <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 5'd0;
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
                    tick_counter <= 5'd0;
                    load_count <= 3'd0;
                    delay_reg <= delay_reg; // hold delay_reg
                    // Shift pattern MSB first: shift right, insert new bit at MSB
                    pattern_shift <= {data, pattern_shift[3:1]};
                end

                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    load_count <= load_count + 1'b1;
                    // Shift delay_reg MSB first
                    delay_reg <= {data, delay_reg[3:1]};
                    pattern_shift <= pattern_shift; // hold pattern_shift (don't care)
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (tick_counter != 5'd0) begin
                            tick_counter <= tick_counter - 1'b1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // Update count output only at start of each 1000-cycle tick (cycle_counter == 0)
                    if (cycle_counter == 10'd0) begin
                        // Since tick_counter counts down after cycle_counter == 999,
                        // current count = tick_counter
                        // But since tick_counter is decremented after 1000 cycles, 
                        // count output should be the tick_counter before decrement
                        // Thus this logic correctly outputs the stable count for 1000 cycles
                        if (tick_counter > 5'd0)
                            count <= tick_counter[3:0];
                        else
                            count <= 4'd0;
                    end
                end

                DONE_WAIT: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    cycle_counter <= 10'd0;
                    load_count <= 3'd0;
                    pattern_shift <= pattern_shift; // hold values, unused
                    delay_reg <= delay_reg;
                    tick_counter <= tick_counter;
                end

                default: begin
                    // Defensive reset
                    state <= SEARCH;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    load_count <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 5'd0;
                end
            endcase

            // On entering COUNTING, initialize tick_counter and cycle_counter
            if ((state != COUNTING) && (next_state == COUNTING)) begin
                // tick_counter = delay_reg + 1 (5 bits to avoid overflow)
                tick_counter <= {1'b0, delay_reg} + 5'd1;
                cycle_counter <= 10'd0;
                count <= delay_reg + 4'd1;
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
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Done when tick_counter reaches 0 and cycle_counter at last cycle (999)
                if ((tick_counter == 5'd0) && (cycle_counter == 10'd999))
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

endmodule