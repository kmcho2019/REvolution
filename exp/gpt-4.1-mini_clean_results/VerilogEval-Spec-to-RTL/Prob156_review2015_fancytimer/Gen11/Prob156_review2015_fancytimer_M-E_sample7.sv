module TopModule(
    input        clk,
    input        reset,    // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State machine states
    typedef enum reg [1:0] {
        IDLE       = 2'b00,
        LOAD_DELAY = 2'b01,
        COUNTING   = 2'b10,
        DONE       = 2'b11
    } state_t;

    reg [1:0] state, next_state;

    // 9-bit shift register: [8:5] delay bits, [4:1] pattern bits, [0] unused flag bit for phase separation
    reg [8:0] shift_reg;

    // Number of delay bits loaded (0 to 4)
    reg [2:0] load_count;

    // Counting registers
    reg [3:0] delay_val;        // extracted delay value (4 bits)
    reg [3:0] countdown;        // counts down from delay+1 to 0 (in time units)
    reg [9:0] cycle_count;      // counts from 0 to 999 for 1000 cycles

    // Sequential logic: state and shift register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 9'd0;
            load_count <= 3'd0;
            delay_val <= 4'd0;
            countdown <= 4'd0;
            cycle_count <= 10'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift in data into lower 4 bits + shift out oldest bits, shift_reg[8:0]
                    // For pattern detection, shift data into bits [3:0], shifting left.
                    // We'll implement shifting as shift_reg = {shift_reg[7:0], data};
                    shift_reg <= {shift_reg[7:0], data};

                    load_count <= 3'd0;
                    cycle_count <= 10'd0;
                    countdown <= 4'd0;
                    delay_val <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                LOAD_DELAY: begin
                    // Shift in delay bits MSB first into bits [8:5]
                    // For this, shift_reg[8:0] = {shift_reg[7:0], data}
                    shift_reg <= {shift_reg[7:0], data};

                    load_count <= load_count + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_count <= 10'd0;
                    countdown <= 4'd0;
                    delay_val <= delay_val;
                end

                COUNTING: begin
                    // Counting down cycles and ticks
                    counting <= 1'b1;
                    done <= 1'b0;

                    // cycle_count counts up to 999
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;

                        if (countdown != 4'd0)
                            countdown <= countdown - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end

                    // Output count according to remaining countdown value
                    // Show countdown-1 while cycle_count < 999, countdown at cycle_count == 999
                    if (countdown == 4'd0) begin
                        count <= 4'd0;
                    end else if (cycle_count == 10'd999) begin
                        count <= countdown;
                    end else begin
                        count <= countdown - 1'b1;
                    end

                    // shift_reg, load_count, delay_val remain unchanged
                    shift_reg <= shift_reg;
                    load_count <= load_count;
                    delay_val <= delay_val;
                end

                DONE: begin
                    // Done asserted, waiting for ack
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;

                    // Hold registers steady
                    shift_reg <= shift_reg;
                    load_count <= load_count;
                    delay_val <= delay_val;
                    countdown <= countdown;
                    cycle_count <= 10'd0;
                end

                default: begin
                    state <= IDLE;
                    shift_reg <= 9'd0;
                    load_count <= 3'd0;
                    delay_val <= 4'd0;
                    countdown <= 4'd0;
                    cycle_count <= 10'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // At transition from LOAD_DELAY to COUNTING, extract delay_val and setup countdown
            if (state == LOAD_DELAY && next_state == COUNTING) begin
                // delay_val is bits [8:5] of shift_reg (4 bits)
                delay_val <= shift_reg[8:5];
                countdown <= shift_reg[8:5] + 4'd1;
                cycle_count <= 10'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Check for pattern "1101" in lowest 4 bits of shift_reg
                // shift_reg[3:0] holds the last 4 bits shifted in (oldest on left)
                if (shift_reg[3:0] == 4'b1101)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                // After 4 delay bits shifted in, go to COUNTING
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end

            COUNTING: begin
                // Finish counting when countdown == 0 and cycle_count == 999 (end of last 1000-cycle block)
                if ((countdown == 4'd0) && (cycle_count == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                // Wait for user ack to restart
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

endmodule