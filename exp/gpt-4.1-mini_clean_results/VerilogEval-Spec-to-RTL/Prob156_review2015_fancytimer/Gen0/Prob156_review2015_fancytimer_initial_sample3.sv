module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    typedef enum reg [1:0] {
        SEARCH      = 2'b00,
        READ_DELAY  = 2'b01,
        COUNT       = 2'b10,
        DONE_STATE  = 2'b11
    } state_t;

    reg [1:0] state, next_state;

    // Shift register for detecting pattern 1101
    reg [3:0] pattern_shift;

    // Delay register for timer value
    reg [3:0] delay_reg;

    // Delay bit counter for reading the 4 bits after pattern
    reg [2:0] delay_bits_read; // counts 0 to 3

    // Counting registers
    reg [9:0] cycle_count; // counts 0 to 999 (1000 cycles per delay step)
    reg [3:0] count_reg;   // current remaining delay value to output

    // Sequential logic: FSM and data registers
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bits_read <= 3'b000;
            cycle_count <= 10'd0;
            count_reg <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0000;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    // Shift in serial data
                    pattern_shift <= {pattern_shift[2:0], data};
                end
                READ_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    // Shift in delay bits MSB first into delay_reg
                    // Each clock shift in one bit from data at delay_bits_read 0..3
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_read <= delay_bits_read + 1'b1;
                end
                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // Counting logic
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        // Decrement count_reg
                        if (count_reg != 4'd0)
                            count_reg <= count_reg - 1'b1;
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end
                DONE_STATE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                end
                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // Update count output according to state
            if (state == COUNT)
                count <= count_reg;
            else
                count <= 4'bxxxx; // don't care, but assign x for clarity
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // Look for pattern 1101 on pattern_shift after shifting in data
                // pattern_shift is updated next cycle, so compare with 1101 directly
                // The pattern 1101 corresponds to bits: [3]=1 [2]=1 [1]=0 [0]=1
                if (pattern_shift == 4'b1101) begin
                    next_state = READ_DELAY;
                end
            end
            READ_DELAY: begin
                // After reading 4 bits delay, move to COUNT state
                if (delay_bits_read == 3'd4) begin
                    next_state = COUNT;
                end
            end
            COUNT: begin
                // count_reg initialized at delay_reg value and decremented each 1000 cycles
                // When count_reg == 0 and cycle_count == 999 (end of last 1000 cycle block)
                if ((count_reg == 4'd0) && (cycle_count == 10'd999)) begin
                    next_state = DONE_STATE;
                end
            end
            DONE_STATE: begin
                // Wait for ack to return to SEARCH state
                if (ack == 1'b1) begin
                    next_state = SEARCH;
                end
            end
        endcase
    end

    // Control signals and registers update for count_reg and delay_bits_read
    always @(posedge clk) begin
        if (reset) begin
            delay_bits_read <= 3'b000;
            count_reg <= 4'd0;
        end else begin
            case (state)
                SEARCH: begin
                    delay_bits_read <= 3'b000;
                    count_reg <= 4'd0;
                end
                READ_DELAY: begin
                    if (delay_bits_read == 3'd4) begin
                        // Load count_reg with delay_reg for counting next cycle
                        count_reg <= delay_reg;
                    end
                end
                COUNT: begin
                    if (cycle_count == 10'd999) begin
                        if (count_reg != 4'd0) begin
                            count_reg <= count_reg - 1'b1;
                        end
                    end
                end
                DONE_STATE: begin
                    delay_bits_read <= 3'b000;
                    count_reg <= 4'd0;
                end
                default: begin
                    delay_bits_read <= 3'b000;
                    count_reg <= 4'd0;
                end
            endcase
        end
    end

endmodule