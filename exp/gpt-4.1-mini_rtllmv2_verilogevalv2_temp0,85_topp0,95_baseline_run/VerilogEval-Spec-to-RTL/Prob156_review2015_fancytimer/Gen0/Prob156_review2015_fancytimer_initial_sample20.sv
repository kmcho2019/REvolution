module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    typedef enum reg [2:0] {
        IDLE = 3'd0,
        LOAD_DELAY = 3'd1,
        COUNTING = 3'd2,
        DONE = 3'd3
    } state_t;
    state_t state, next_state;

    // Shift register to detect pattern 1101
    reg [3:0] pattern_shift;

    // Delay register to store 4 bit delay value
    reg [3:0] delay;

    // Counters for counting cycles
    reg [9:0] cycle_counter; // counts 0 to 999 (1000 cycles)
    reg [3:0] delay_counter; // counts down from delay to 0

    // Internal signals
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Sequential logic for state, pattern shift, delay load, counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0;
            delay <= 4'b0;
            cycle_counter <= 10'd0;
            delay_counter <= 4'd0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bxxxx; // don't care, but assign x to indicate don't care
                    // Shift in data to pattern_shift to detect 1101
                    pattern_shift <= {pattern_shift[2:0], data};
                end
                LOAD_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bxxxx; // don't care
                    // Shift in data bits MSB first into delay register:
                    // We'll shift delay left and shift in data at LSB,
                    // after 4 bits delay will have correct MSB first data.
                    delay <= {delay[2:0], data};
                end
                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;
                    // count outputs current remaining delay_counter value
                    count <= delay_counter;
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (delay_counter != 4'd0)
                            delay_counter <= delay_counter - 1'b1;
                        else
                            delay_counter <= 4'd0;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end
                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_detected)
                    next_state = LOAD_DELAY;
                else
                    next_state = IDLE;
            end
            LOAD_DELAY: begin
                // Wait until 4 bits loaded into delay register
                // We can track bits shifted by counting from zero to 4
                // But here, as delay register is 4 bits and we shift one bit per cycle,
                // we can use a shift counter to know when 4 bits are received.
                // We need a separate counter for load delay bits.
                // Let's implement a load_bit_count register.
                // We'll add that below.
                if (load_bit_count == 4)
                    next_state = COUNTING;
                else
                    next_state = LOAD_DELAY;
            end
            COUNTING: begin
                // When counting done (delay_counter == 0 and cycle_counter == 999)
                if ((delay_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE;
                else
                    next_state = COUNTING;
            end
            DONE: begin
                if (ack)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Shift bit count for LOAD_DELAY state
    reg [2:0] load_bit_count;

    always @(posedge clk) begin
        if (reset) begin
            load_bit_count <= 3'd0;
        end else begin
            if (state == LOAD_DELAY) begin
                load_bit_count <= load_bit_count + 1'b1;
            end else begin
                load_bit_count <= 3'd0;
            end
        end
    end

    // On transition from IDLE to LOAD_DELAY, clear delay register
    always @(posedge clk) begin
        if (reset) begin
            delay <= 4'd0;
        end else if ((state == IDLE) && (next_state == LOAD_DELAY)) begin
            delay <= 4'd0;
        end
    end

    // On transition from LOAD_DELAY to COUNTING, initialize counters
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 10'd0;
            delay_counter <= 4'd0;
        end else if ((state == LOAD_DELAY) && (next_state == COUNTING)) begin
            cycle_counter <= 10'd0;
            delay_counter <= delay;
        end
    end

endmodule