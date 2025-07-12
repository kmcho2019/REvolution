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
        IDLE       = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNT      = 2'd2,
        WAIT_ACK   = 2'd3
    } state_t;

    state_t state, next_state;

    // Shift register for detecting pattern 1101 (4 bits)
    reg [3:0] pattern_shift;

    // Delay register for 4 bits (MSB first)
    reg [3:0] delay_reg;
    reg [2:0] bits_loaded; // count bits loaded for delay (0 to 4)

    // Counters for timing
    reg [9:0] cycle_counter;   // counts 999 down to 0 (10 bits)
    reg [3:0] segment_counter; // counts delay+1 down to 0 segments

    // FSM next state logic combinational
    always @(*) begin
        case(state)
            IDLE: 
                if(pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
                else
                    next_state = IDLE;

            LOAD_DELAY:
                if(bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;

            COUNT:
                if((segment_counter == 4'd0) && (cycle_counter == 10'd0))
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;

            WAIT_ACK:
                if(ack)
                    next_state = IDLE;
                else
                    next_state = WAIT_ACK;

            default:
                next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            bits_loaded <= 3'd0;
            cycle_counter <= 10'd0;
            segment_counter <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'bxxxx; // don't-care, set to x
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    count <= 4'bxxxx; // don't-care

                    // Shift pattern_shift left by 1, insert new bit at LSB (MSB-first input means first bit comes earliest)
                    // To detect pattern '1101' MSB first, shift left and bring new bit at LSB, so bits arrive in order:
                    // cycle0: pattern_shift[3] = old[2], new bit in LSB: pattern_shift = {old[2:0], data}
                    // After 4 clocks, pattern_shift holds last 4 bits, MSB first in pattern_shift[3]
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Clear delay loader
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;

                    // Clear counters
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                LOAD_DELAY: begin
                    done <= 1'b0;
                    counting <= 1'b0;

                    // shift delay_reg left by 1, insert new bit at LSB, because MSB-first input means first bit is MSB, so as bits come
                    // The first loaded bit is MSB, so shift left and put new bit in LSB keeps MSB at bit 3 after all loads
                    // Actually, to load MSB first with serial input, shift delay_reg left and put new bit in LSB each cycle
                    delay_reg <= {delay_reg[2:0], data};

                    bits_loaded <= bits_loaded + 1'b1;

                    // pattern_shift holds detected pattern, but no update needed here to avoid incorrect detection during delay load
                    pattern_shift <= pattern_shift;

                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;

                    count <= 4'bxxxx; // don't-care
                end

                COUNT: begin
                    done <= 1'b0;
                    counting <= 1'b1;

                    // pattern_shift and delay_reg stay stable
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    bits_loaded <= bits_loaded;

                    if(cycle_counter == 10'd0) begin
                        // segment finished, load cycle_counter to 999 if segment_counter>0 and decrement segment_counter
                        if(segment_counter != 4'd0) begin
                            cycle_counter <= 10'd999;
                            segment_counter <= segment_counter - 1'b1;
                        end else begin
                            // Should not happen here, because when segment_counter=0 and cycle_counter=0, FSM goes to WAIT_ACK
                            cycle_counter <= 10'd0;
                            segment_counter <= 4'd0;
                        end
                    end else begin
                        cycle_counter <= cycle_counter - 1'b1;
                    end

                    // Output count = current segment_counter - 1 if cycle_counter>0, else segment_counter
                    // Because segment_counter counts how many segments remain including current one,
                    // count output should represent which segment is currently counting:
                    // For example, for delay=5, segment_counter starts at 6:
                    // count=5 for 1000 cycles (cycle_counter 999->0)
                    // then count=4 for 1000 cycles, and so forth
                    // Since segment_counter is decremented when cycle_counter=0,
                    // the count output should be segment_counter - 1 + (cycle_counter==0 ? 0 : 1)
                    // But to keep it simple and exact per problem spec, output count = segment_counter - 1.

                    // Note: when segment_counter>0, count = segment_counter -1, when segment_counter=0 count=0.
                    // But count is 4 bits unsigned, so avoid negative values.

                    if(segment_counter != 4'd0)
                        count <= segment_counter - 1'b1;
                    else
                        count <= 4'd0;
                end

                WAIT_ACK: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'bxxxx; // don't-care

                    pattern_shift <= 4'b0000;
                    delay_reg <= delay_reg;
                    bits_loaded <= bits_loaded;

                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                end

                default: begin
                    // default safe reset
                    state <= IDLE;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;
                    cycle_counter <= 10'd0;
                    segment_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx;
                end
            endcase

            // On transition from LOAD_DELAY to COUNT, initialize counters
            if(state == LOAD_DELAY && next_state == COUNT) begin
                // delay_reg now holds delay in MSB first order, but we shifted left each bit,
                // so the first loaded bit is MSB. So delay_reg is ready as-is.

                // segment_counter = delay_reg + 1
                segment_counter <= delay_reg + 4'd1;

                // cycle_counter = 999 (start counting first segment)
                cycle_counter <= 10'd999;
            end
        end
    end

endmodule