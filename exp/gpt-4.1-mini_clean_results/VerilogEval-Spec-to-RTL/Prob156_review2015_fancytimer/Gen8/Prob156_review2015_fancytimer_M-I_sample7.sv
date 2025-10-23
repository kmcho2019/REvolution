module TopModule (
    input  wire       clk,
    input  wire       reset,   // synchronous active-high reset
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // State one-hot encoding
    localparam [3:0]
        S_SEARCH   = 4'b0001,
        S_LOAD     = 4'b0010,
        S_COUNT    = 4'b0100,
        S_WAIT_ACK = 4'b1000;

    reg [3:0] state, state_next;
    reg [3:0] state_d;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay register (4 bits)
    reg [3:0] delay_reg;
    reg [2:0] delay_bit_count; // Counts 0..4 loaded bits

    // Single 14-bit counter counts total cycles from 0 to (delay+1)*1000 -1
    // Max delay=15 → max count= (15+1)*1000 -1 = 15999
    reg [13:0] cycle_counter;

    // Compute total cycles in a register for clarity
    reg [13:0] total_cycles;

    // Pattern matched signal
    wire pattern_matched = (pattern_shift == 4'b1101);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= S_SEARCH;
        else
            state <= state_next;
    end

    // State history for entry detection
    always @(posedge clk) begin
        if (reset)
            state_d <= S_SEARCH;
        else
            state_d <= state;
    end

    // Entry detection signals (one clock pulse)
    wire entry_search   = (state == S_SEARCH)   && (state_d != S_SEARCH);
    wire entry_load     = (state == S_LOAD)     && (state_d != S_LOAD);
    wire entry_count    = (state == S_COUNT)    && (state_d != S_COUNT);
    wire entry_wait_ack = (state == S_WAIT_ACK) && (state_d != S_WAIT_ACK);

    // Next state logic
    always @(*) begin
        state_next = state;
        case(state)
            S_SEARCH: begin
                if (pattern_matched)
                    state_next = S_LOAD;
            end
            S_LOAD: begin
                if (delay_bit_count == 3'd4)
                    state_next = S_COUNT;
            end
            S_COUNT: begin
                // Transition to WAIT_ACK when counting done
                if (cycle_counter == total_cycles)
                    state_next = S_WAIT_ACK;
            end
            S_WAIT_ACK: begin
                if (ack)
                    state_next = S_SEARCH;
            end
            default: state_next = S_SEARCH;
        endcase
    end

    // Pattern detection and delay loading
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift   <= 4'b0000;
            delay_reg       <= 4'b0000;
            delay_bit_count <= 3'd0;
        end else begin
            case(state)
                S_SEARCH: begin
                    // Shift in new bit at LSB (left shift) for pattern detection
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Clear delay loading registers
                    delay_reg       <= 4'b0000;
                    delay_bit_count <= 3'd0;
                end
                S_LOAD: begin
                    // Shift in MSB first delay bits: shift left, insert new bit at LSB
                    // Because first loaded bit is MSB, so shifting left and inserting LSB reconstructs correctly.
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1'b1;
                end
                default: begin
                    // Hold values steady
                    pattern_shift   <= pattern_shift;
                    delay_reg       <= delay_reg;
                    delay_bit_count <= delay_bit_count;
                end
            endcase
        end
    end

    // Total cycles register updated on count entry
    always @(posedge clk) begin
        if (reset)
            total_cycles <= 14'd0;
        else if (entry_count)
            // total_cycles = (delay + 1)*1000 - 1
            total_cycles <= (({10'd0, delay_reg} + 1) * 14'd1000) - 1;
    end

    // Cycle counter for counting timer
    always @(posedge clk) begin
        if (reset)
            cycle_counter <= 14'd0;
        else if (entry_count)
            cycle_counter <= 14'd0;
        else if (state == S_COUNT) begin
            if (cycle_counter < total_cycles)
                cycle_counter <= cycle_counter + 1'b1;
        end else
            cycle_counter <= 14'd0;
    end

    // Output logic
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'bxxxx; // don't care
        end else begin
            case(state)
                S_SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end
                S_LOAD: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end
                S_COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // count is number of 1000-cycle intervals remaining:
                    // remaining intervals = total_intervals - completed intervals
                    // completed intervals = cycle_counter / 1000 (integer division)
                    // total_intervals = delay_reg + 1
                    // count = total_intervals - completed_intervals - 1
                    // Simplify count as:
                    // count = (delay_reg + 1) - 1 - (cycle_counter / 1000)
                    //       = delay_reg - (cycle_counter / 1000)
                    //
                    // During first 1000 cycles, count = delay_reg (e.g. delay_reg=5 means count=5 for 1000 cycles)
                    // Then decrements every 1000 cycles
                    // When cycle_counter reaches total_cycles (delay+1)*1000-1, count hits 0 for last 1000 cycles
                    // So count must never go below 0.
                    //
                    // Calculate:
                    // temp_count = delay_reg - (cycle_counter / 1000)
                    // Clamp to zero if negative (should never be negative).
                    //
                    // Implement with integer division
                    // cycle_counter is 14 bits (max 15999), division by 1000 fits in 4 bits
                    //
                    // Implement using division:
                    // div = cycle_counter / 1000 (integer div)
                    // Using Verilog division operator / is OK for synthesis for constants.
                    //
                    // So:
                    // count = delay_reg - div;
                    //
                    // We'll clamp count at zero to avoid any negative underflow
                    //
                    // Note: delay_reg is 4 bits, div can be 0..delay_reg+1
                    //
                    // So assign count accordingly

                    integer div;
                    integer tmp_count;
                    div = cycle_counter / 1000;
                    tmp_count = delay_reg - div;
                    if (tmp_count < 0)
                        count <= 4'd0;
                    else
                        count <= tmp_count[3:0];
                end
                S_WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx;
                end
                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end
            endcase
        end
    end

endmodule