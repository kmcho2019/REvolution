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
typedef enum logic [1:0] {
    SEARCH     = 2'd0,
    LOAD_DELAY = 2'd1,
    COUNT      = 2'd2,
    DONE       = 2'd3
} state_t;

reg [1:0] state, next_state;

// Shift register to detect pattern 1101
reg [3:0] pattern_shift;

// Delay register to store delay bits
reg [3:0] delay_reg;

// Counter to track how many delay bits loaded (0 to 4)
reg [2:0] load_count;

// Micro counter counts 0..999 clock cycles within one delay step
reg [9:0] micro_counter; // 10 bits enough for 0-999

// Remaining steps count: counts from delay+1 down to 0
reg [4:0] remaining_steps; // 5 bits to hold values up to 17

// Sequential logic: state and counters
always @(posedge clk) begin
    if (reset) begin
        state          <= SEARCH;
        pattern_shift  <= 4'b0;
        delay_reg      <= 4'b0;
        load_count     <= 3'd0;
        micro_counter  <= 10'd0;
        remaining_steps<= 5'd0;
        counting       <= 1'b0;
        done           <= 1'b0;
        count          <= 4'b0;
    end else begin
        state <= next_state;

        case(state)
            SEARCH: begin
                // Shift pattern register for pattern detection
                pattern_shift <= {pattern_shift[2:0], data};
                load_count    <= 3'd0;
                counting     <= 1'b0;
                done         <= 1'b0;
                count        <= 4'b0;
                micro_counter <= 10'd0;
                remaining_steps <= 5'd0;
            end

            LOAD_DELAY: begin
                // Shift in delay bits MSB first
                delay_reg <= {delay_reg[2:0], data};
                load_count <= load_count + 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0;
                micro_counter <= 10'd0;
                remaining_steps <= 5'd0;
            end

            COUNT: begin
                counting <= 1'b1;
                done <= 1'b0;

                if (micro_counter == 10'd999) begin
                    micro_counter <= 10'd0;
                    if (remaining_steps != 0)
                        remaining_steps <= remaining_steps - 1'b1;
                end else begin
                    micro_counter <= micro_counter + 1'b1;
                end

                // Output count = remaining_steps - 1 when micro_counter is 0 to 999
                // Because each step is 1000 cycles, count shows current step number from delay down to 0
                if (remaining_steps > 0)
                    count <= remaining_steps[3:0] - 1'b1;
                else
                    count <= 4'd0;
            end

            DONE: begin
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'b0;
                micro_counter <= 10'd0;
                remaining_steps <= 5'd0;
                load_count <= 3'd0;
                pattern_shift <= pattern_shift; // hold pattern_shift
                delay_reg <= delay_reg;         // hold delay_reg
            end

            default: begin
                // Default state fallback
                state <= SEARCH;
                pattern_shift  <= 4'b0;
                delay_reg      <= 4'b0;
                load_count     <= 3'd0;
                micro_counter  <= 10'd0;
                remaining_steps<= 5'd0;
                counting       <= 1'b0;
                done           <= 1'b0;
                count          <= 4'b0;
            end
        endcase
    end
end

// Next state logic
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
            if (load_count == 3'd4)
                next_state = COUNT;
            else
                next_state = LOAD_DELAY;
        end

        COUNT: begin
            // When counting done: remaining_steps == 0 and micro_counter == 999 (one cycle after last step)
            if (remaining_steps == 0 && micro_counter == 10'd999)
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

// Initialize remaining_steps at transition from LOAD_DELAY to COUNT
always @(posedge clk) begin
    if (reset) begin
        // handled in main sequential block
    end else begin
        if (state == LOAD_DELAY && next_state == COUNT) begin
            // Start counting steps = delay + 1
            remaining_steps <= delay_reg + 1'b1;
            micro_counter <= 10'd0;
        end
    end
end

endmodule