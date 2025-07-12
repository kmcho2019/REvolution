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
typedef enum reg [1:0] {
    SEARCH = 2'd0,
    LOAD_DELAY = 2'd1,
    COUNT = 2'd2,
    DONE = 2'd3
} state_t;

reg [1:0] state, next_state;

// Shift register to detect pattern 1101
reg [3:0] pattern_shift;

// Delay register (4 bits, MSB first)
reg [3:0] delay_reg;

// Number of delay bits loaded (0 to 4)
reg [2:0] load_count;

// Micro counter counts 0..999 cycles per step
reg [9:0] micro_counter;

// Remaining steps: counts down from delay+1 to 0
reg [4:0] remaining_steps;

always @(posedge clk) begin
    if (reset) begin
        state <= SEARCH;
        pattern_shift <= 4'b0;
        delay_reg <= 4'b0;
        load_count <= 3'd0;
        micro_counter <= 10'd0;
        remaining_steps <= 5'd0;
        counting <= 1'b0;
        done <= 1'b0;
        count <= 4'b0;
    end else begin
        state <= next_state;

        case (state)
            SEARCH: begin
                // Shift pattern register
                pattern_shift <= {pattern_shift[2:0], data};
                // Clear others
                load_count <= 3'd0;
                counting <= 1'b0;
                done <= 1'b0;
                micro_counter <= 10'd0;
                remaining_steps <= 5'd0;
                count <= 4'b0;
            end

            LOAD_DELAY: begin
                // Shift in delay bits MSB first
                delay_reg <= {delay_reg[2:0], data};
                load_count <= load_count + 1'b1;
                counting <= 1'b0;
                done <= 1'b0;
                micro_counter <= 10'd0;
                remaining_steps <= 5'd0;
                count <= 4'b0;
            end

            COUNT: begin
                counting <= 1'b1;
                done <= 1'b0;

                // Counting logic: increment micro_counter each clock
                if (micro_counter == 10'd999) begin
                    micro_counter <= 10'd0;
                    if (remaining_steps != 0)
                        remaining_steps <= remaining_steps - 1'b1;
                end else begin
                    micro_counter <= micro_counter + 1'b1;
                end

                // Output count shows current delay step (counting down)
                // We keep count stable during each 1000 cycle period.
                // When micro_counter < 999, count = remaining_steps - 1 (if remaining_steps > 0)
                // When micro_counter == 999, next cycle decrements remaining_steps, so update count accordingly
                if (remaining_steps != 0) begin
                    if (micro_counter == 10'd999)
                        count <= (remaining_steps - 1'b1)[3:0];
                    else
                        count <= (remaining_steps)[3:0];
                end else begin
                    count <= 4'd0;
                end
            end

            DONE: begin
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'b0;
                // Hold registers stable
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                load_count <= 3'd0;
                micro_counter <= 10'd0;
                remaining_steps <= 5'd0;
            end

            default: begin
                // Safety fallback
                state <= SEARCH;
                pattern_shift <= 4'b0;
                delay_reg <= 4'b0;
                load_count <= 3'd0;
                micro_counter <= 10'd0;
                remaining_steps <= 5'd0;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0;
            end
        endcase

        // On transition from LOAD_DELAY to COUNT, load remaining_steps and reset micro_counter
        if (state == LOAD_DELAY && next_state == COUNT) begin
            remaining_steps <= delay_reg + 1'b1;
            micro_counter <= 10'd0;
        end
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
            // Move to DONE after counting all steps: remaining_steps == 0 and micro_counter == 999
            if ((remaining_steps == 0) && (micro_counter == 10'd999))
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
    endcase
end

endmodule