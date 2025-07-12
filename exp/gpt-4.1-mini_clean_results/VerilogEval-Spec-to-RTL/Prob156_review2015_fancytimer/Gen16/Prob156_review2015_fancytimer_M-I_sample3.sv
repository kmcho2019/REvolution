module TopModule(
    input  wire       clk,
    input  wire       reset,    // synchronous active high
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM state encoding
    typedef enum reg [1:0] {
        SEARCH     = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNT      = 2'd2,
        DONE       = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for detecting pattern 1101 (MSB-first)
    reg [3:0] pattern_shift;

    // Shift register for loading delay bits MSB-first
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_loaded; // counts 0..4

    // Single down counter for total cycles: (delay+1)*1000 - 1
    reg [13:0] total_cycle_counter;

    // Next state combinational logic
    always @(*) begin
        case(state)
            SEARCH: 
                if(pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
                else
                    next_state = SEARCH;

            LOAD_DELAY:
                if(delay_bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;

            COUNT:
                if(total_cycle_counter == 14'd0)
                    next_state = DONE;
                else
                    next_state = COUNT;

            DONE:
                if(ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;

            default:
                next_state = SEARCH;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if(reset) begin
            state <= SEARCH;

            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            delay_bits_loaded <= 3'd0;

            total_cycle_counter <= 14'd0;

            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift right, insert new bit at MSB to capture MSB-first input pattern
                    // e.g. old[3:0] = {b3,b2,b1,b0}
                    // new pattern_shift = {data, b3, b2, b1}
                    pattern_shift <= {data, pattern_shift[3:1]};

                    // Clear delay loading registers
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;

                    total_cycle_counter <= 14'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // don't-care, use 0 for stability
                end

                LOAD_DELAY: begin
                    // Shift delay_reg right, insert new bit at MSB (MSB-first)
                    delay_reg <= {data, delay_reg[3:1]};
                    delay_bits_loaded <= delay_bits_loaded + 1'b1;

                    // Keep pattern_shift stable (pattern already detected)
                    pattern_shift <= pattern_shift;

                    total_cycle_counter <= 14'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                COUNT: begin
                    // Hold pattern_shift and delay_reg steady
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;

                    counting <= 1'b1;
                    done <= 1'b0;

                    if(total_cycle_counter != 14'd0)
                        total_cycle_counter <= total_cycle_counter - 1;
                    else
                        total_cycle_counter <= 14'd0;

                    // Compute count = remaining segments = total_cycle_counter / 1000
                    // Since 1000 is decimal, dividing by 1000 corresponds to:
                    // remaining segments = total_cycle_counter / 1000
                    // We can do integer division by 1000 using division operator since it's synthesizable for small constants.

                    count <= total_cycle_counter / 14'd1000;
                end

                DONE: begin
                    // Hold stable values, wait for ack
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    delay_bits_loaded <= delay_bits_loaded;
                    total_cycle_counter <= 14'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                default: begin
                    // Defensive defaults
                    state <= SEARCH;

                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    delay_bits_loaded <= 3'd0;

                    total_cycle_counter <= 14'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end
            endcase

            // Initialize counting counters at LOAD_DELAY->COUNT transition
            if(state == LOAD_DELAY && next_state == COUNT) begin
                // Initialize total_cycle_counter = (delay_reg + 1)*1000 - 1 (zero based)
                total_cycle_counter <= (delay_reg + 4'd1)*14'd1000 - 14'd1;

                // Other registers are stable and outputs will update next cycle
            end
        end
    end

endmodule