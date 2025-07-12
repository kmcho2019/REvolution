module TopModule(
    input           clk,
    input           reset,  // synchronous active high
    input           data,
    output reg [3:0] count,
    output reg      counting,
    output reg      done,
    input           ack
);

    // One-hot FSM states
    localparam SEARCH = 4'b0001,
               LOAD   = 4'b0010,
               COUNT  = 4'b0100,
               DONE   = 4'b1000;

    reg [3:0] state, next_state;

    // Pattern detection shift register for '1101'
    reg [3:0] pattern_shift;

    // Delay register to load 4 bits MSB first
    reg [3:0] delay_reg;
    reg [2:0] delay_count; // counts bits loaded from 0 to 4

    // Main cycle counter, counts down from (delay+1)*1000 to 0
    reg [13:0] cycle_counter;

    // count_next needs to be reg since it's assigned inside always block
    reg [3:0] count_next;
    reg [13:0] counter_for_count;
    integer i;

    always @(*) begin
        // Compute count as the block index, counting down from delay to 0
        // Blocks: (delay + 1) blocks of 1000 cycles
        // block_index = (cycle_counter + 999) / 1000 - 1, saturate at 0
        // Implement division by checking which 1000-cycle range cycle_counter falls into.
        counter_for_count = cycle_counter + 14'd999;
        count_next = 4'd0;
        for (i=15; i>=1; i=i-1) begin
            if (counter_for_count >= i*1000)
                count_next = i - 1;
        end
    end

    // Synchronous FSM and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            delay_count <= 3'd0;
            cycle_counter <= 14'd0;

            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data bit MSB last
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_count <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_counter <= 14'd0;

                    // Outputs during SEARCH
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD: begin
                    // Shift in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    delay_count <= delay_count + 1'b1;

                    pattern_shift <= pattern_shift; // hold pattern

                    cycle_counter <= 14'd0;

                    // Outputs during LOAD
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNT: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_count <= delay_count;

                    // Count down cycles if not zero
                    if (cycle_counter != 0)
                        cycle_counter <= cycle_counter - 1'b1;
                    else
                        cycle_counter <= 0;

                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= count_next; // update count based on cycle_counter
                end

                DONE: begin
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_count <= delay_count;
                    cycle_counter <= 14'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    state <= SEARCH;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_count <= 3'd0;
                    cycle_counter <= 14'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Detect '1101' pattern
                if (pattern_shift == 4'b1101)
                    next_state = LOAD;
                else
                    next_state = SEARCH;
            end

            LOAD: begin
                if (delay_count == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD;
            end

            COUNT: begin
                // When cycle_counter hits zero, counting finished
                if (cycle_counter == 14'd0)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end

            default:
                next_state = SEARCH;
        endcase
    end

    // Load cycle_counter at LOAD->COUNT transition
    reg load_state_d;
    always @(posedge clk) begin
        if (reset) begin
            load_state_d <= 1'b0;
        end else begin
            load_state_d <= (state == LOAD);
        end
    end

    wire load_to_count = (load_state_d == 1'b1) && (state == COUNT);

    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 14'd0;
        end else if (load_to_count) begin
            // Initialize cycle_counter to (delay + 1)*1000 cycles
            // delay_reg is 4 bits, so max 15, safe to multiply by 1000 directly
            cycle_counter <= (delay_reg + 1) * 14'd1000;
        end
    end

endmodule