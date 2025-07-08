module TopModule (
    input  wire       clk,
    input  wire       reset,
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM states
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for detecting pattern 1101
    reg [3:0] pattern_shift;

    // Shift register for loading delay bits (4 bits)
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_count; // counts 0 to 3 for bits loaded

    // Counting logic
    reg [9:0] cycle_counter;    // counts from 0 to 999 (1000 cycles)
    reg [3:0] remaining_delay;  // counts down from delay to 0

    // Pattern to detect
    localparam [3:0] START_PATTERN = 4'b1101;

    // Synchronous FSM and registers
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers and FSM state
            state           <= SEARCH;
            pattern_shift   <= 4'b0000;
            delay_reg       <= 4'b0000;
            delay_bit_count <= 3'd0;
            cycle_counter   <= 10'd0;
            remaining_delay <= 4'd0;

            count    <= 4'bxxxx; // don't care on reset
            counting <= 1'b0;
            done     <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    done     <= 1'b0;
                    counting <= 1'b0;
                    count    <= 4'bxxxx; // don't care

                    // Shift in data bit for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    // When pattern is detected, transition will be handled in next_state logic
                end

                LOAD_DELAY: begin
                    done     <= 1'b0;
                    counting <= 1'b0;
                    count    <= 4'bxxxx; // don't care

                    // Shift in delay bits MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1'b1;
                end

                COUNT: begin
                    done     <= 1'b0;
                    counting <= 1'b1;
                    count    <= remaining_delay;

                    // Count clock cycles up to 999
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (remaining_delay != 0)
                            remaining_delay <= remaining_delay - 1'b1;
                        else
                            remaining_delay <= 4'd0;
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                DONE: begin
                    done     <= 1'b1;
                    counting <= 1'b0;
                    count    <= 4'bxxxx; // don't care
                end

                default: begin
                    // Should not happen
                    done     <= 1'b0;
                    counting <= 1'b0;
                    count    <= 4'bxxxx;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                // If pattern_shift matches start pattern, go to LOAD_DELAY
                if (pattern_shift == START_PATTERN)
                    next_state = LOAD_DELAY;
            end

            LOAD_DELAY: begin
                if (delay_bit_count == 3'd4)
                    next_state = COUNT;
            end

            COUNT: begin
                // When counting done (delay 0 and 1000 cycles elapsed)
                if ((remaining_delay == 4'd0) && (cycle_counter == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack signal high before going back to SEARCH
                if (ack)
                    next_state = SEARCH;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Synchronous reset of counters and registers when changing state
    always @(posedge clk) begin
        if (!reset) begin
            case (next_state)
                SEARCH: begin
                    // Reset pattern shift register and counters
                    pattern_shift   <= 4'b0000;
                    delay_reg       <= 4'b0000;
                    delay_bit_count <= 3'd0;
                    cycle_counter   <= 10'd0;
                    remaining_delay <= 4'd0;
                end

                LOAD_DELAY: begin
                    // delay_bit_count increments in always block
                end

                COUNT: begin
                    // At start of COUNT, initialize counters
                    if (state != COUNT) begin
                        cycle_counter   <= 10'd0;
                        remaining_delay <= delay_reg;
                    end
                end

                DONE: begin
                    // Nothing special
                end

                default: ;
            endcase
        end
    end

endmodule