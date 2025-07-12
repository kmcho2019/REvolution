module TopModule(
    input         clk,
    input         reset,   // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // States
    typedef enum logic [1:0] {
        SEARCH     = 2'b00,
        LOAD_DELAY = 2'b01,
        COUNTING   = 2'b10,
        DONE       = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] shift_reg;      // For pattern detection in SEARCH and delay loading in LOAD_DELAY
    reg [2:0] load_cnt;       // counts bits loaded in LOAD_DELAY (0 to 4)
    reg [3:0] delay;          // delay bits loaded from data after pattern
    reg [13:0] cycle_counter; // counts remaining cycles for timer, max (15+1)*1000=16000 cycles fit in 14 bits (max 16383)

    // Sequential logic: state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_reg <= 4'b0;
            load_cnt <= 3'd0;
            delay <= 4'b0;
            cycle_counter <= 14'd0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data for pattern detection
                    shift_reg <= {shift_reg[2:0], data};
                    load_cnt <= 3'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    cycle_counter <= 14'd0;
                    delay <= delay; // hold delay stable
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first
                    shift_reg <= {shift_reg[2:0], data};
                    load_cnt <= load_cnt + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    cycle_counter <= 14'd0;
                    delay <= delay; // hold delay until loaded
                end

                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (cycle_counter != 0)
                        cycle_counter <= cycle_counter - 1'b1;

                    // Calculate which block we're in for count output
                    // Each block = 1000 cycles
                    // Remaining blocks = (cycle_counter / 1000)
                    // Output count = remaining blocks - 1 if remaining blocks > 0 else 0

                    // To avoid division in hardware, do integer division with subtraction:
                    // cycle_counter/1000 = number of blocks left (0 to delay)
                    // but delay+1 blocks total

                    // We'll use integer division by 1000 using a combinational expression below
                    count <= (cycle_counter / 1000) ? (cycle_counter / 1000 - 1) : 4'd0;

                    shift_reg <= shift_reg;
                    load_cnt <= load_cnt;
                    delay <= delay;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;
                    shift_reg <= shift_reg;
                    load_cnt <= 3'd0;
                    cycle_counter <= 14'd0;
                    delay <= delay;
                end

                default: begin
                    state <= SEARCH;
                    shift_reg <= 4'b0;
                    load_cnt <= 3'd0;
                    delay <= 4'b0;
                    cycle_counter <= 14'd0;
                    count <= 4'b0;
                    counting <= 1'b0;
                    done <= 1'b0;
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
                if (load_cnt == 3'd4) 
                    next_state = COUNTING;
            end

            COUNTING: begin
                if (cycle_counter == 14'd0)
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // On LOAD_DELAY completion, latch delay from shift_reg and initialize cycle_counter
    always @(posedge clk) begin
        if (reset) begin
            delay <= 4'b0;
            cycle_counter <= 14'd0;
        end else begin
            if ((state == LOAD_DELAY) && (load_cnt == 3'd4)) begin
                delay <= shift_reg; // shift_reg holds last 4 delay bits after loading
                cycle_counter <= ((shift_reg + 1'b1) * 14'd1000) - 1'b1; // count down from total cycles-1 to 0
            end
        end
    end

endmodule