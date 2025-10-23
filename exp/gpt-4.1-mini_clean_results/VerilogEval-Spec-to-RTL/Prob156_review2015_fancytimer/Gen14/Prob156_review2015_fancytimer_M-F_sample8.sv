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
    reg [2:0] load_count; // 0..4 bits loaded

    // Counting counters
    reg [3:0] tick_count;     // counts down from delay to 0 inclusive
    reg [9:0] cycle_count;    // counts 0 to 999 (1000 cycles per tick)

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            load_count <= 3'd0;
            tick_count <= 4'd0;
            cycle_count <= 10'd0;
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
                    tick_count <= 4'd0;
                    cycle_count <= 10'd0;
                    load_count <= 3'd0;

                    // Shift pattern MSB first: shift left and input data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    tick_count <= 4'd0;
                    cycle_count <= 10'd0;

                    // Shift delay bits MSB first: shift left and input data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    load_count <= load_count + 1'b1;
                    // pattern_shift unchanged
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // cycle_count counts 0..999
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (tick_count != 4'd0)
                            tick_count <= tick_count - 1'b1;
                        // else remain at 0 until done
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                    // Output count = current tick_count (remaining ticks), stable during 1000 cycles
                    count <= tick_count;
                end

                DONE_WAIT: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    tick_count <= 4'd0;
                    cycle_count <= 10'd0;
                    load_count <= 3'd0;
                    // pattern_shift and delay_reg hold last values but ignored now
                end

                default: begin
                    state <= SEARCH;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    load_count <= 3'd0;
                    tick_count <= 4'd0;
                    cycle_count <= 10'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Wait until pattern 1101 detected (MSB first)
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Counting finishes after tick_count reaches 0 and cycle_count finishes 1000 cycles
                if (tick_count == 4'd0 && cycle_count == 10'd999)
                    next_state = DONE_WAIT;
            end

            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // On transition from LOAD_DELAY to COUNTING, load tick_count from delay_reg
    // Use an always_ff style logic by detecting this transition.
    reg [1:0] state_d; // delayed state
    always @(posedge clk) begin
        state_d <= state;
    end

    always @(posedge clk) begin
        if (reset) begin
            tick_count <= 4'd0;
        end else if (state == COUNTING && state_d == LOAD_DELAY) begin
            // Initialize tick_count with delay_reg
            tick_count <= delay_reg;
            cycle_count <= 10'd0;
        end
    end

endmodule