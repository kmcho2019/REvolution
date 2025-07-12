module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    typedef enum logic [1:0] {
        SEARCH = 2'd0,
        READ_DELAY = 2'd1,
        COUNT = 2'd2,
        DONE = 2'd3
    } state_t;

    state_t state, next_state;

    // For detecting pattern 1101 in a 4-bit shift register
    reg [3:0] pattern_shift;

    // For reading delay bits (4 bits, MSB first)
    reg [3:0] delay;
    reg [2:0] delay_bits_read; // counts 0 to 3

    // Counting related
    reg [9:0] cycle_count; // counts up to 1000 cycles (0 to 999)
    reg [3:0] remaining;   // remaining count to output during counting (down counts from delay to 0)

    // Sequential logic: state update, pattern shift, counters
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay <= 4'b0000;
            delay_bits_read <= 3'd0;
            cycle_count <= 10'd0;
            remaining <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in data to pattern_shift
                    pattern_shift <= {pattern_shift[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    delay_bits_read <= 3'd0;
                end
                READ_DELAY: begin
                    // Shift delay left, shift in data at LSB (MSB first)
                    // We read one bit per cycle, starting with MSB first
                    delay <= {delay[2:0], data};
                    delay_bits_read <= delay_bits_read + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
                COUNT: begin
                    done <= 1'b0;
                    counting <= 1'b1;
                    count <= remaining;

                    // count cycles up to 1000 then decrement remaining
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (remaining != 4'd0) begin
                            remaining <= remaining - 1'b1;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
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
                // Check if pattern_shift equals 1101 (4'b1101)
                if (pattern_shift == 4'b1101) begin
                    next_state = READ_DELAY;
                end
            end
            READ_DELAY: begin
                if (delay_bits_read == 3'd3) begin
                    // read last bit this cycle, next cycle start counting
                    next_state = COUNT;
                end
            end
            COUNT: begin
                // Wait until remaining count hits zero and cycle_count reaches 999 (complete last 1000 cycle count)
                if ((remaining == 4'd0) && (cycle_count == 10'd999)) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                // Wait for ack == 1 to return to SEARCH
                if (ack) begin
                    next_state = SEARCH;
                end
            end
        endcase
    end

    // Load remaining at transition from READ_DELAY to COUNT
    // We do it on the cycle state moves to COUNT, so detect this rising edge of state
    reg state_dly;
    always @(posedge clk) begin
        if (reset) begin
            state_dly <= 1'b0;
        end else begin
            state_dly <= (state == READ_DELAY);
        end
    end

    wire start_counting = (state == COUNT) && (state_dly);

    always @(posedge clk) begin
        if (reset) begin
            remaining <= 4'd0;
            cycle_count <= 10'd0;
        end else begin
            if (start_counting) begin
                remaining <= delay;
                cycle_count <= 10'd0;
            end else if (state == COUNT) begin
                // cycle_count and remaining updated in main sequential block
                // nothing here
            end else begin
                remaining <= remaining; // keep value
                cycle_count <= 10'd0;
            end
        end
    end

endmodule