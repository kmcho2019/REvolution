module TopModule(
    input  wire       clk,
    input  wire       reset,    // synchronous active high
    input  wire       data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input  wire       ack
);

    // FSM states
    localparam SEARCH     = 2'd0;
    localparam LOAD_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam WAIT_ACK   = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift;

    // Delay register for 4 bits (MSB first)
    reg [3:0] delay_reg;
    reg [2:0] bits_loaded; // counts 0 to 4

    // Single 14-bit counter for counting cycles
    reg [13:0] cycle_counter; // Max 16000 cycles (delay+1)*1000 max 17*1000=17000, but 14 bits covers 16383, safe as max delay is 15

    // Next state logic
    always @(*) begin
        case(state)
            SEARCH: 
                if(pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
                else
                    next_state = SEARCH;
            LOAD_DELAY:
                if(bits_loaded == 3'd4)
                    next_state = COUNT;
                else
                    next_state = LOAD_DELAY;
            COUNT:
                if(cycle_counter == 14'd0)
                    next_state = WAIT_ACK;
                else
                    next_state = COUNT;
            WAIT_ACK:
                if(ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT_ACK;
            default:
                next_state = SEARCH;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            delay_reg <= 4'b0000;
            bits_loaded <= 3'd0;
            cycle_counter <= 14'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                SEARCH: begin
                    // Shift in new bit (LSB)
                    pattern_shift <= {pattern_shift[2:0], data};

                    // Reset delay loading registers
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;

                    // Clear counting signals and outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    cycle_counter <= 14'd0;
                end

                LOAD_DELAY: begin
                    // Shift delay_reg left, input MSB first, so shift left and input at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    bits_loaded <= bits_loaded + 1'b1;

                    // No pattern shift update during load delay to avoid confusion
                    pattern_shift <= pattern_shift;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    cycle_counter <= 14'd0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    pattern_shift <= pattern_shift;
                    delay_reg <= delay_reg;
                    bits_loaded <= bits_loaded;

                    // Decrement cycle counter if not zero
                    if (cycle_counter != 14'd0)
                        cycle_counter <= cycle_counter - 1'b1;
                    else
                        cycle_counter <= 14'd0;

                    // count output = remaining segments = cycle_counter/1000
                    // To avoid complex division, use integer division by 1000 as:
                    // count = cycle_counter / 1000;
                    // Since count is 4 bits and max delay is 15, max count=15
                    count <= cycle_counter / 14'd1000;
                end

                WAIT_ACK: begin
                    done <= 1'b1;
                    counting <= 1'b0;
                    count <= 4'd0;
                    pattern_shift <= 4'b0000;
                    delay_reg <= delay_reg;
                    bits_loaded <= bits_loaded;
                    cycle_counter <= 14'd0;
                end

                default: begin
                    state <= SEARCH;
                    pattern_shift <= 4'b0000;
                    delay_reg <= 4'b0000;
                    bits_loaded <= 3'd0;
                    cycle_counter <= 14'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase

            // On transition from LOAD_DELAY to COUNT, initialize cycle_counter
            if(state == LOAD_DELAY && next_state == COUNT) begin
                // cycle_counter = (delay + 1) * 1000
                cycle_counter <= ( {10'd0, delay_reg} + 14'd1 ) * 14'd1000;
            end
        end
    end

endmodule