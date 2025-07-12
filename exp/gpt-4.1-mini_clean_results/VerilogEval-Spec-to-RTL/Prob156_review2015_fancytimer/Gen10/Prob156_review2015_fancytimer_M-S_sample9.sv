module TopModule(
    input        clk,
    input        reset,    // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // FSM states
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection
    reg [3:0] shift_pattern;

    // For loading delay bits
    reg [2:0] load_count;      // Counts bits loaded: 0 to 3
    reg [3:0] delay_reg;       // Loaded delay value

    // Counting timers
    reg [9:0] cycle_count;     // Counts 0..999 clock cycles
    reg [4:0] block_count;     // Counts delay+1 blocks, max 17

    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_pattern <= 4'b0;
            load_count <= 3'd0;
            delay_reg <= 4'd0;
            cycle_count <= 10'd0;
            block_count <= 5'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in serial data bit for pattern detection
                    shift_pattern <= {shift_pattern[2:0], data};

                    // Clear loading and counting registers
                    load_count <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_count <= 10'd0;
                    block_count <= 5'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    load_count <= load_count + 1'b1;

                    // Keep other signals cleared
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Increment cycle counter
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        // Decrement block count if > 0
                        if (block_count != 0)
                            block_count <= block_count - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                    // Output remaining blocks - 1
                    if (block_count > 0)
                        count <= block_count - 1;
                    else
                        count <= 4'd0;

                    // Keep other signals stable
                    shift_pattern <= shift_pattern;
                    load_count <= load_count;
                    delay_reg <= delay_reg;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;

                    // Hold registers stable
                    shift_pattern <= shift_pattern;
                    load_count <= load_count;
                    delay_reg <= delay_reg;
                    cycle_count <= 10'd0;
                    block_count <= 5'd0;
                end

                default: begin
                    state <= SEARCH;
                    shift_pattern <= 4'b0;
                    load_count <= 3'd0;
                    delay_reg <= 4'd0;
                    cycle_count <= 10'd0;
                    block_count <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Look for pattern 1101 in shift_pattern
                if (shift_pattern == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // After loading 4 bits delay, go to COUNTING
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When counting finished: block_count=0 and cycle_count=999 (end of last block)
                if ((block_count == 0) && (cycle_count == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                // Wait for user ack to restart searching
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Initialize block_count at the cycle after delay loading completes
    always @(posedge clk) begin
        if (reset) begin
            block_count <= 5'd0;
        end else if ((state == LOAD_DELAY) && (load_count == 3'd4)) begin
            // delay_reg is fully loaded here, set block_count = delay + 1
            block_count <= {1'b0, delay_reg} + 1'b1;
        end
    end

endmodule