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
                    // Shift in new bit at LSB for pattern detection (left shift by 1)
                    pattern_shift <= {pattern_shift[2:0], data};
                    // Clear delay loading registers
                    delay_reg       <= 4'b0000;
                    delay_bit_count <= 3'd0;
                end
                S_LOAD: begin
                    // Shift in MSB first delay bits: shift left, insert new bit at LSB
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

    // counting and done outputs registered synchronously
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                S_COUNT:    counting <= 1'b1;
                default:    counting <= 1'b0;
            endcase

            done <= (state == S_WAIT_ACK);
        end
    end

    // Compute count output combinationally: count = delay_reg - (cycle_counter / 1000), clamp at 0
    // cycle_counter max 15999 so div result max 15
    reg [3:0] count_calc;
    reg [3:0] div_1000;

    always @(*) begin
        // Compute div_1000 = cycle_counter / 1000 with integer division
        // Since cycle_counter max 15999, div_1000 max 15
        div_1000 = 4'd0;
        if (cycle_counter >= 14'd15000)
            div_1000 = 4'd15;
        else if (cycle_counter >= 14'd14000)
            div_1000 = 4'd14;
        else if (cycle_counter >= 14'd13000)
            div_1000 = 4'd13;
        else if (cycle_counter >= 14'd12000)
            div_1000 = 4'd12;
        else if (cycle_counter >= 14'd11000)
            div_1000 = 4'd11;
        else if (cycle_counter >= 14'd10000)
            div_1000 = 4'd10;
        else if (cycle_counter >= 14'd9000)
            div_1000 = 4'd9;
        else if (cycle_counter >= 14'd8000)
            div_1000 = 4'd8;
        else if (cycle_counter >= 14'd7000)
            div_1000 = 4'd7;
        else if (cycle_counter >= 14'd6000)
            div_1000 = 4'd6;
        else if (cycle_counter >= 14'd5000)
            div_1000 = 4'd5;
        else if (cycle_counter >= 14'd4000)
            div_1000 = 4'd4;
        else if (cycle_counter >= 14'd3000)
            div_1000 = 4'd3;
        else if (cycle_counter >= 14'd2000)
            div_1000 = 4'd2;
        else if (cycle_counter >= 14'd1000)
            div_1000 = 4'd1;
        else
            div_1000 = 4'd0;

        // Compute count_calc = delay_reg - div_1000, clamp to zero
        if (delay_reg >= div_1000)
            count_calc = delay_reg - div_1000;
        else
            count_calc = 4'd0;
    end

    // Output count registered synchronously only during counting, else don't care
    always @(posedge clk) begin
        if (reset)
            count <= 4'bxxxx;
        else if (state == S_COUNT)
            count <= count_calc;
        else
            count <= 4'bxxxx; // don't care
    end

endmodule