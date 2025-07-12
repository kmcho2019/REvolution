module TopModule(
    input         clk,
    input         reset, // synchronous active high
    input         data,
    output reg [3:0] count,
    output reg    counting,
    output reg    done,
    input         ack
);

    // State encoding
    parameter SEARCH     = 2'd0;
    parameter LOAD_DELAY = 2'd1;
    parameter COUNTING   = 2'd2;
    parameter DONE_WAIT  = 2'd3;

    reg [1:0] state, next_state;

    // For pattern detection: shift in data MSB first
    reg [3:0] pattern_shift;

    // For loading delay bits MSB first
    reg [3:0] delay_reg;
    reg [2:0] load_count; // 0..4 bits loaded

    // Total cycles counter: counts from 0 to (delay+1)*1000 -1
    // Max delay = 15, max total cycles = 16*1000 = 16000, fits in 15 bits
    reg [14:0] total_cycle_count;

    // Calculate total cycles based on delay_reg:
    wire [14:0] total_cycles = (delay_reg + 4'd1) * 15'd1000;

    // Current "tick" number derived from total_cycle_count
    // ticks = delay+1 - 1 - current_tick_index
    // current_tick_index = total_cycle_count / 1000
    wire [3:0] current_tick_index = total_cycle_count / 1000; // 0..delay
    wire [3:0] tick_remaining = (delay_reg + 4'd1) - 1 - current_tick_index;

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'd0;
            delay_reg <= 4'd0;
            load_count <= 3'd0;
            total_cycle_count <= 15'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    total_cycle_count <= 15'd0;
                    load_count <= 3'd0;

                    // Shift in data MSB first: shift left, insert new bit at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                end
                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    total_cycle_count <= 15'd0;

                    // Shift in delay bits MSB first: shift left + insert data at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    load_count <= load_count + 1'b1;
                    // pattern_shift held
                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (total_cycle_count == total_cycles - 1)
                        total_cycle_count <= total_cycle_count; // Hold max value
                    else
                        total_cycle_count <= total_cycle_count + 1'b1;

                    // Output count = current tick_remaining (0..delay)
                    count <= tick_remaining;
                end
                DONE_WAIT: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                    total_cycle_count <= 15'd0;
                    load_count <= 3'd0;
                    // pattern_shift and delay_reg hold values but not used now
                end
                default: begin
                    // Defensive default to SEARCH
                    state <= SEARCH;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    pattern_shift <= 4'd0;
                    delay_reg <= 4'd0;
                    load_count <= 3'd0;
                    total_cycle_count <= 15'd0;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                if (total_cycle_count == total_cycles - 1)
                    next_state = DONE_WAIT;
            end
            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

endmodule