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
localparam SEARCH     = 2'd0;
localparam LOAD_DELAY = 2'd1;
localparam COUNT      = 2'd2;
localparam DONE       = 2'd3;

reg [1:0] state, next_state;

// Shift register to detect pattern 1101
reg [3:0] pattern_shift;

// Delay register (4 bits)
reg [3:0] delay_reg;

// Counter for total cycles counting: counts from 0 up to (delay+1)*1000 -1
// Maximum delay=15, so max cycles = 16*1000=16000 < 2^15
reg [14:0] total_cycle_count; // enough bits for up to 32000 cycles

// Number of cycles to count in total = (delay+1)*1000
reg [14:0] total_cycles_to_count;

// Counter for number of delay bits loaded (0 to 4)
reg [2:0] load_bit_count;

// Synchronize sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Reset all
        state <= SEARCH;
        pattern_shift <= 4'b0000;
        delay_reg <= 4'b0000;
        load_bit_count <= 3'd0;
        total_cycle_count <= 15'd0;
        total_cycles_to_count <= 15'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'b0000;
    end else begin
        state <= next_state;

        case(state)
            SEARCH: begin
                // Shift in data bit for pattern detection
                pattern_shift <= {pattern_shift[2:0], data};
                load_bit_count <= 3'd0;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;
                total_cycle_count <= 15'd0;
                total_cycles_to_count <= 15'd0;
            end

            LOAD_DELAY: begin
                // Shift in delay bits MSB first into delay_reg
                delay_reg <= {delay_reg[2:0], data};
                load_bit_count <= load_bit_count + 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;
                total_cycle_count <= 15'd0;
                total_cycles_to_count <= 15'd0;
            end

            COUNT: begin
                // Counting state
                counting <= 1'b1;
                done <= 1'b0;
                pattern_shift <= pattern_shift; // hold
                delay_reg <= delay_reg;         // hold
                load_bit_count <= load_bit_count; // hold

                if (total_cycle_count < total_cycles_to_count - 1) begin
                    total_cycle_count <= total_cycle_count + 1'b1;
                end

                // Compute count output = remaining delay steps (countdown by 1 every 1000 cycles)
                // remaining_delay = delay - (total_cycle_count / 1000)
                // To get integer division by 1000, use division by 1000 is difficult in hardware,
                // but since 1000 is not power of two, implement by comparing total_cycle_count intervals.

                // Use a simple combinational calculation below in the next always block for count
                // So count updated combinationally.

            end

            DONE: begin
                counting <= 1'b0;
                done <= 1'b1;
                pattern_shift <= pattern_shift; // hold
                delay_reg <= delay_reg;         // hold
                load_bit_count <= 3'd0;
                total_cycle_count <= 15'd0;
                total_cycles_to_count <= 15'd0;
                count <= 4'b0000; // don't care
            end

            default: begin
                // Default to SEARCH
                state <= SEARCH;
                counting <= 1'b0;
                done <= 1'b0;
                pattern_shift <= 4'b0000;
                delay_reg <= 4'b0000;
                load_bit_count <= 3'd0;
                total_cycle_count <= 15'd0;
                total_cycles_to_count <= 15'd0;
                count <= 4'b0000;
            end
        endcase

        // Initialize counting parameters when entering COUNT state
        // Detect state transition SEARCH/LOAD_DELAY -> COUNT
        if (state != COUNT && next_state == COUNT) begin
            // total cycles = (delay + 1)*1000
            total_cycles_to_count <= (delay_reg + 4'd1) * 15'd1000;
            total_cycle_count <= 15'd0;
            // count will be updated combinationally
        end
    end
end

// FSM combinational next state logic (consolidated)
always @(*) begin
    next_state = state;
    case(state)
        SEARCH: begin
            if (pattern_shift == 4'b1101)
                next_state = LOAD_DELAY;
            else
                next_state = SEARCH;
        end

        LOAD_DELAY: begin
            if (load_bit_count == 3'd4)
                next_state = COUNT;
            else
                next_state = LOAD_DELAY;
        end

        COUNT: begin
            // Finish counting when total_cycle_count reaches total_cycles_to_count-1
            if (total_cycle_count == total_cycles_to_count - 1 && total_cycles_to_count != 0)
                next_state = DONE;
            else
                next_state = COUNT;
        end

        DONE: begin
            if (ack)
                next_state = SEARCH;
            else
                next_state = DONE;
        end

        default: next_state = SEARCH;
    endcase
end

// Combinational logic to update count output during COUNT state
always @(*) begin
    if (state == COUNT) begin
        // Calculate remaining delay as:
        // remaining_steps = delay - (total_cycle_count / 1000)
        // integer division by 1000:
        // total_cycle_count / 1000 approx: loop subtract or divide by integer

        // Use a simple way: total_cycle_count / 1000 = total_cycle_count / 10'd1000
        // As 1000 fits in 10 bits, total_cycle_count max 15 bits

        // Use division operator (synthesizable in modern tools)
        // Remaining delay = delay_reg - (total_cycle_count / 1000)
        // Clamp to 0 if negative (should not happen)
        integer tmp_div;
        tmp_div = total_cycle_count / 10'd1000;
        if (tmp_div > delay_reg)
            count = 4'd0;
        else
            count = delay_reg - tmp_div[3:0];
    end else begin
        count = 4'b0000; // Don't care as per spec
    end
end

endmodule