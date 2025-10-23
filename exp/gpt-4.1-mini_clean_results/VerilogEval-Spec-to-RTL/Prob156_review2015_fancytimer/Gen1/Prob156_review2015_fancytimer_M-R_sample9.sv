module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

    // FSM states
    typedef enum reg [1:0] {
        SEARCH      = 2'b00,
        READ_DELAY  = 2'b01,
        COUNT       = 2'b10,
        DONE_STATE  = 2'b11
    } state_t;

    reg [1:0] state, next_state;

    // Shift register for detecting pattern 1101 (4 bits)
    reg [3:0] pattern_shift;

    // Delay register for timer value
    reg [3:0] delay_reg;

    // Number of delay bits read (0 to 4)
    reg [2:0] delay_bits_read;

    // Counting registers
    reg [9:0] cycle_count; // counts 0 to 999 (1000 cycles per delay step)
    reg [3:0] count_reg;   // current remaining delay value to output

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Check if shifted in pattern matches 1101
                if (pattern_shift == 4'b1101)
                    next_state = READ_DELAY;
            end
            READ_DELAY: begin
                if (delay_bits_read == 3'd4)
                    next_state = COUNT;
            end
            COUNT: begin
                if ((count_reg == 4'd0) && (cycle_count == 10'd999))
                    next_state = DONE_STATE;
            end
            DONE_STATE: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Sequential logic block, synchronous with clock and reset
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bits_read <= 3'd0;
            cycle_count <= 10'd0;
            count_reg <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    // Shift in data into pattern_shift MSB first: shift left, insert LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_read <= 3'd0;
                    cycle_count <= 10'd0;
                    count_reg <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care when not counting
                end
                READ_DELAY: begin
                    // Shift in delay bits MSB first into delay_reg
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_read <= delay_bits_read + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                    cycle_count <= 10'd0;
                    count_reg <= 4'd0;
                end
                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Keep count output updated with current count_reg
                    count <= count_reg;

                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (count_reg != 4'd0) begin
                            count_reg <= count_reg - 1'b1;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
                DONE_STATE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care when not counting
                    pattern_shift <= 4'b0000;
                    delay_bits_read <= 3'd0;
                    cycle_count <= 10'd0;
                    count_reg <= 4'd0;
                end
            endcase

            // Load count_reg with delay_reg at transition from READ_DELAY to COUNT
            // We detect transition by current state READ_DELAY and next_state COUNT
            if (state == READ_DELAY && next_state == COUNT) begin
                count_reg <= delay_reg;
                cycle_count <= 10'd0; // reset cycle_count at start of counting
            end
        end
    end

endmodule