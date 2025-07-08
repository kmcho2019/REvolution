module TopModule(
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
    localparam READ_DELAY = 2'd1;
    localparam COUNTING   = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection in SEARCH state
    reg [3:0] pattern_shift;

    // Shift register for reading delay bits in READ_DELAY state
    reg [3:0] delay_reg;

    // Bit counter for reading 4 bits in READ_DELAY state
    reg [2:0] read_bit_count; // 3 bits enough for 0-4

    // Cycle counter counts 0..999 per "count" decrement
    reg [9:0] cycle_count;

    // Count down counter for number of 1000-cycle blocks remaining
    reg [3:0] count_down;

    // Synchronous state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            read_bit_count <= 3'd0;
            cycle_count <= 10'd0;
            count_down <= 4'd0;
            count <= 4'bx; // don't care
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bx;
                    // Shift in data
                    pattern_shift <= {pattern_shift[2:0], data};
                end

                READ_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bx;
                    // Shift in delay bits, MSB first on data input
                    delay_reg <= {delay_reg[2:0], data};
                    read_bit_count <= read_bit_count + 1'b1;
                end

                COUNTING: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // cycle_count counts 0..999, increment each clock
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'd0;
                        if (count_down != 4'd0) begin
                            count_down <= count_down - 1'b1;
                            count <= count_down - 1'b1;
                        end else begin
                            // Finished counting
                            counting <= 1'b0;
                            count <= 4'd0;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1'b1;
                    end
                end

                DONE: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'bx;
                end

                default: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bx;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                // Look for pattern 1101 on pattern_shift
                if (pattern_shift == 4'b1101) begin
                    next_state = READ_DELAY;
                end
            end

            READ_DELAY: begin
                if (read_bit_count == 3'd4) begin
                    next_state = COUNTING;
                end
            end

            COUNTING: begin
                // Transition to DONE when count_down reaches zero and cycle_count also at max (counting last cycle)
                if ((count_down == 4'd0) && (cycle_count == 10'd999)) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                // Wait for ack to return to SEARCH
                if (ack) begin
                    next_state = SEARCH;
                end
            end

            default: next_state = SEARCH;
        endcase
    end

    // Reset the read_bit_count at start of READ_DELAY state
    always @(posedge clk) begin
        if (reset) begin
            read_bit_count <= 3'd0;
        end else if (state == SEARCH && next_state == READ_DELAY) begin
            read_bit_count <= 3'd0;
        end
    end

    // Load count_down and initial count at start of COUNTING state
    always @(posedge clk) begin
        if (reset) begin
            count_down <= 4'd0;
            count <= 4'bx;
            cycle_count <= 10'd0;
        end else if (state == READ_DELAY && next_state == COUNTING) begin
            count_down <= delay_reg;
            count <= delay_reg;
            cycle_count <= 10'd0;
        end
    end

endmodule