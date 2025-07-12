module TopModule(
    input        clk,
    input        reset,    // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // States
    typedef enum reg [1:0] {
        SEARCH     = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNTING   = 2'd2,
        DONE       = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_pattern;  // for detecting 1101 pattern
    reg [2:0] load_count;     // counts bits loaded in LOAD_DELAY (0-4)
    reg [3:0] delay_reg;      // delay loaded in LOAD_DELAY

    reg [9:0] cycle_count;    // 0..999 cycle counter within one block
    reg [4:0] block_count;    // counts delay+1 blocks (max 17)

    // Sequential logic: FSM and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_pattern <= 4'b0;
            load_count <= 3'b0;
            delay_reg <= 4'b0;
            cycle_count <= 10'b0;
            block_count <= 5'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in serial data for pattern detection
                    shift_pattern <= {shift_pattern[2:0], data};

                    // Clear counters and outputs
                    load_count <= 3'b0;
                    delay_reg <= 4'b0;
                    cycle_count <= 10'b0;
                    block_count <= 5'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first
                    // Append data as LSB: delay_reg = (delay_reg<<1) | data
                    delay_reg <= {delay_reg[2:0], data};
                    load_count <= load_count + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    cycle_count <= 10'b0;
                    block_count <= 5'b0;
                    shift_pattern <= shift_pattern; // hold pattern
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Increment cycle_count
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'b0;
                        if (block_count != 0)
                            block_count <= block_count - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                    // Output remaining blocks - 1 as count (4 bits)
                    if (block_count != 0)
                        count <= block_count - 1'b1;
                    else
                        count <= 4'b0;

                    // Hold other registers stable
                    shift_pattern <= shift_pattern;
                    load_count <= load_count;
                    delay_reg <= delay_reg;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;

                    // Hold registers stable
                    shift_pattern <= shift_pattern;
                    load_count <= load_count;
                    delay_reg <= delay_reg;
                    cycle_count <= 10'b0;
                    block_count <= 5'b0;
                end

                default: begin
                    // default safe reset to SEARCH
                    state <= SEARCH;
                    shift_pattern <= 4'b0;
                    load_count <= 3'b0;
                    delay_reg <= 4'b0;
                    cycle_count <= 10'b0;
                    block_count <= 5'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // If pattern 1101 detected, go to LOAD_DELAY
                if (shift_pattern == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // After 4 bits loaded, go to COUNTING
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // When last cycle of last block completes, go to DONE
                if (block_count == 0 && cycle_count == 10'd999)
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack to restart searching
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // block_count initialization: set at the cycle when LOAD_DELAY finishes (load_count==4)
    always @(posedge clk) begin
        if (reset) begin
            block_count <= 5'b0;
        end else if (state == LOAD_DELAY && load_count == 3'd4) begin
            block_count <= delay_reg + 1'b1;
        end
    end

endmodule