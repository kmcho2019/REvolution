module TopModule(
    input        clk,
    input        reset,    // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State encoding
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    reg [3:0] shift_reg;       // For pattern detection and delay loading
    reg [2:0] load_bit_cnt;    // Counts bits loaded in LOAD_DELAY (0 to 3)

    reg [9:0] cycle_cnt;       // 0 to 999 cycle counter
    reg [4:0] block_cnt;       // (delay+1), max 17 (4 bits delay + 1)

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'b0;
            load_bit_cnt <= 3'd0;
            cycle_cnt <= 10'd0;
            block_cnt <= 5'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data for pattern detection
                    shift_reg <= {shift_reg[2:0], data};

                    // Clear counters and outputs
                    load_bit_cnt <= 3'd0;
                    cycle_cnt <= 10'd0;
                    block_cnt <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first
                    // After 4 bits loaded, delay in shift_reg
                    shift_reg <= {shift_reg[2:0], data};
                    load_bit_cnt <= load_bit_cnt + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_cnt <= 10'd0;
                    block_cnt <= block_cnt; // hold until end of LOAD_DELAY
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // cycle_cnt increments every clock
                    if (cycle_cnt == 10'd999) begin
                        cycle_cnt <= 10'd0;
                        if (block_cnt != 0)
                            block_cnt <= block_cnt - 1'b1;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                        block_cnt <= block_cnt; // hold block_cnt
                    end

                    // Output remaining blocks - 1 as count
                    // If block_cnt > 0, count = block_cnt -1, else 0
                    count <= (block_cnt != 0) ? (block_cnt - 1) : 4'd0;

                    shift_reg <= shift_reg;    // Hold shift_reg stable
                    load_bit_cnt <= load_bit_cnt;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;

                    // Hold counters stable
                    shift_reg <= shift_reg;
                    load_bit_cnt <= load_bit_cnt;
                    cycle_cnt <= 10'd0;
                    block_cnt <= 5'd0;
                end

                default: begin
                    state <= SEARCH;
                    shift_reg <= 4'b0;
                    load_bit_cnt <= 3'd0;
                    cycle_cnt <= 10'd0;
                    block_cnt <= 5'd0;
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
                // Detect pattern 1101 in shift_reg
                if (shift_reg == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (load_bit_cnt == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Transition to DONE when count complete: block_cnt=0 and cycle_cnt=999
                if ((block_cnt == 0) && (cycle_cnt == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack=1 to return to SEARCH
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Initialize block_cnt when entering COUNTING state (load_bit_cnt == 4)
    // To avoid multiple assignments, use a flag to detect LOAD_DELAY done cycle
    reg load_delay_done;
    always @(posedge clk) begin
        if (reset)
            load_delay_done <= 1'b0;
        else
            load_delay_done <= (state == LOAD_DELAY) && (load_bit_cnt == 3'd4);
    end

    always @(posedge clk) begin
        if (load_delay_done)
            block_cnt <= shift_reg + 1'b1;
    end

endmodule