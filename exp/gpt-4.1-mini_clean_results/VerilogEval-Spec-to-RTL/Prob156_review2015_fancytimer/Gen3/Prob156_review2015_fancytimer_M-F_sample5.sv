module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// State encoding
localparam SEARCH     = 2'd0;
localparam LOAD_DELAY = 2'd1;
localparam COUNT      = 2'd2;
localparam DONE       = 2'd3;

reg [1:0] state, next_state;

// Shift register for pattern detection (4 bits)
reg [3:0] pattern_shift;

// Delay register: stores 4 delay bits, MSB first shifted in
reg [3:0] delay_reg;

// Load counter: number of delay bits loaded (0..4)
reg [2:0] load_count;

// Micro counter: counts 0..999 clock cycles per delay step
reg [9:0] micro_counter; // 10 bits for 1000 counts

// Remaining steps counter: counts down from delay+1 to 0
reg [4:0] remaining_steps; // up to 17 (max delay=15+1)

// Sequential logic: state, outputs, counters
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

        case (state)
            SEARCH: begin
                // Shift in data to pattern_shift for pattern detection
                pattern_shift <= {pattern_shift[2:0], data};
                load_count <= 3'd0;
                delay_reg <= delay_reg; // hold last delay_reg (not strictly needed)
                micro_counter <= 10'd0;
                remaining_steps <= 5'd0;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0;
            end

            LOAD_DELAY: begin
                // Shift in delay bits MSB first
                delay_reg <= {delay_reg[2:0], data};
                load_count <= load_count + 1'b1;
                pattern_shift <= pattern_shift; // hold pattern_shift
                micro_counter <= 10'd0;
                remaining_steps <= 5'd0;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0;
            end

            COUNT: begin
                pattern_shift <= pattern_shift; // hold pattern_shift
                delay_reg <= delay_reg;         // hold delay_reg
                load_count <= load_count;       // hold load_count
                done <= 1'b0;
                counting <= 1'b1;

                // Counting logic:
                if (micro_counter == 10'd999) begin
                    micro_counter <= 10'd0;
                    if (remaining_steps != 0)
                        remaining_steps <= remaining_steps - 1'b1;
                    else
                        remaining_steps <= remaining_steps; // remain 0
                end else begin
                    micro_counter <= micro_counter + 1'b1;
                    remaining_steps <= remaining_steps; // hold steady during counting
                end

                // Output count shows current remaining step from delay down to 0
                // We output the current remaining_steps - 1 when micro_counter<999,
                // because we count down after micro_counter hits 999.
                if (remaining_steps != 0) begin
                    if (micro_counter == 10'd999)
                        count <= (remaining_steps - 1'b1)[3:0];
                    else
                        count <= (remaining_steps)[3:0];
                end else begin
                    // When remaining_steps=0 and counting finished, count=0
                    count <= 4'd0;
                end
            end

            DONE: begin
                // Wait for ack to restart
                pattern_shift <= pattern_shift; // hold pattern_shift
                delay_reg <= delay_reg;         // hold delay_reg
                load_count <= 3'd0;
                micro_counter <= 10'd0;
                remaining_steps <= 5'd0;
                counting <= 1'b0;
                done <= 1'b1;
                count <= 4'b0; // don't-care output
            end

            default: begin
                // Safety default to SEARCH
                state          <= SEARCH;
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
    case (state)
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
            // Transition to DONE after counting all steps:
            // When remaining_steps == 0 and micro_counter == 999 (end of last step)
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

        default: next_state = SEARCH;
    endcase
end

// Initialize remaining_steps at transition LOAD_DELAY -> COUNT
// Use a register to detect this transition
reg load_delay_d;
always @(posedge clk) begin
    if (reset) begin
        load_delay_d <= 1'b0;
    end else begin
        load_delay_d <= (state == LOAD_DELAY);
    end
end

always @(posedge clk) begin
    if (reset) begin
        remaining_steps <= 5'd0;
    end else if ((load_delay_d == 1'b1) && (state == COUNT)) begin
        // Load delay + 1 at COUNT entry
        // Ensure no glitch by loading only at this transition
        remaining_steps <= delay_reg + 1'b1;
        micro_counter <= 10'd0;
    end
end

endmodule