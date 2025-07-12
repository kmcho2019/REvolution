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
    localparam IDLE       = 2'd0;
    localparam READ_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // 4-bit shift register for pattern detection (always shift every cycle in IDLE)
    reg [3:0] pattern_shift;

    // Delay register and bit count during READ_DELAY
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_received; // counts from 0 to 3

    // Single 15-bit counter for total cycles = (delay +1)*1000
    reg [14:0] total_cycles;

    // FSM sequential logic and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            delay_bits_received <= 3'd0;
            total_cycles <= 15'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift pattern register left by 1, input new bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loading variables (not counting)
                    delay_reg <= 4'b0;
                    delay_bits_received <= 3'd0;
                    total_cycles <= 15'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end

                READ_DELAY: begin
                    // Shift delay_reg left by 1, input current data bit at LSB (MSB first)
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_received <= delay_bits_received + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    // pattern_shift holds its last value
                    pattern_shift <= pattern_shift;
                    total_cycles <= 15'd0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    // total_cycles counts down each cycle if > 0
                    if (total_cycles != 15'd0)
                        total_cycles <= total_cycles - 1'b1;
                    else
                        total_cycles <= 15'd0;

                    // count is number of remaining 1000-cycle blocks (upper 4 bits of 15-bit count)
                    // total_cycles is cycles remaining: each block = 1000 cycles
                    // upper bits [14:10] represent how many full 1000-cycle blocks remain
                    count <= total_cycles[14:11]; // 4 bits: bits 14 down to 11 (since 2^11=2048 > 1000)
                    // But to get block count = total_cycles / 1000, we can do approximate by dividing total_cycles by 1000.
                    // Since 1000 < 1024 = 2^10, use bits [14:10] to represent count blocks:
                    // count = total_cycles[14:10] is the integer division by 1024 which is close but slightly off.
                    // To be exact:
                    // We'll do integer division by 1000 as (delay+1), so use a small LUT or a different approach.

                    // Instead, store count at state transition as (delay+1), then decrement every 1000 cycles.

                    // To do it simpler, we keep total_cycles and also a cycle_counter mod 1000.

                    // We'll fix this in the combinational FSM.

                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;

                    // Hold other regs stable
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_received <= delay_bits_received;
                    total_cycles <= total_cycles;
                end

                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Check if last 4 input bits match pattern 1101
                if (pattern_shift == 4'b1101)
                    next_state = READ_DELAY;
            end

            READ_DELAY: begin
                // After 4 delay bits loaded, move to COUNT
                if (delay_bits_received == 3'd3)
                    next_state = COUNT;
            end

            COUNT: begin
                // When total_cycles reaches zero, go to DONE
                if (total_cycles == 15'd0)
                    next_state = DONE;
            end

            DONE: begin
                // Wait for ack to return to IDLE
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end

    // Extra registers to correctly implement countdown of (delay+1)*1000 cycles and output count
    // We introduce a 10-bit cycle_counter counting 0..999, to decrement the delay count every 1000 cycles
    reg [9:0] cycle_counter;       // counts 0..999
    reg [4:0] blocks_remaining;    // counts down from delay+1 to 0

    // Initialize blocks_remaining and cycle_counter at the moment we enter COUNT
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 10'd0;
            blocks_remaining <= 5'd0;
        end else begin
            if (state == READ_DELAY && next_state == COUNT) begin
                blocks_remaining <= delay_reg + 5'd1;
                cycle_counter <= 10'd0;
            end else if (state == COUNT) begin
                if (cycle_counter == 10'd999) begin
                    cycle_counter <= 10'd0;
                    if (blocks_remaining != 0)
                        blocks_remaining <= blocks_remaining - 1'b1;
                end else begin
                    cycle_counter <= cycle_counter + 1'b1;
                end
            end else begin
                // Not counting state: clear counters
                cycle_counter <= 10'd0;
                blocks_remaining <= 5'd0;
            end
        end
    end

    // Override total_cycles for information or debugging (optional)
    // Not needed since we use blocks_remaining and cycle_counter separately

    // Update count output: output blocks_remaining[3:0] during counting, else 0
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0;
        end else begin
            if (state == COUNT) begin
                count <= blocks_remaining[3:0];
            end else begin
                count <= 4'b0; // don't care, keep zero here
            end
        end
    end

    // counting and done signals updated only in main FSM always block above

endmodule