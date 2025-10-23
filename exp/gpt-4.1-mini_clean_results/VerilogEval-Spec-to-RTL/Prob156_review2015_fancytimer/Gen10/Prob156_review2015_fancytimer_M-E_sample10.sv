module TopModule(
    input  clk,
    input  reset,   // synchronous active-high reset
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE     = 2'b00,  // searching pattern
        LOAD     = 2'b01,  // loading 4 delay bits
        COUNT    = 2'b10,  // counting down timer
        WAIT_ACK = 2'b11   // done, wait for ack
    } state_t;

    state_t state, next_state;

    // Pattern detection shift register
    reg [3:0] pattern_shift;

    // Delay bits shift register and bit count
    reg [3:0] delay_reg;
    reg [1:0] load_bit_idx;  // 0 to 3

    // Cycle counter: counts down total cycles = (delay+1)*1000
    // 16 bits enough for max 16*1000 = 16000 cycles
    reg [15:0] cycle_counter;

    // Wire the start condition: pattern detected on pattern_shift == 4'b1101
    wire pattern_detected = (pattern_shift == 4'b1101);

    // Compute total cycles to count at LOAD->COUNT transition:
    // total_cycles = (delay + 1) * 1000
    wire [15:0] total_cycles = ( {12'd0, delay_reg} + 16'd1 ) * 16'd1000;

    // Output count value (number of 1000-cycle blocks remaining minus 1)
    // For remaining cycles in cycle_counter, compute integer division by 1000:
    // count = (remaining_cycles-1) / 1000 when counting (or delay at start)
    // Handle special case when cycle_counter==0 => count=0
    wire [3:0] block_count = (cycle_counter == 0) ? 4'd0 : ( (cycle_counter - 16'd1) / 16'd1000 );

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            load_bit_idx <= 2'd0;
            cycle_counter <= 16'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift pattern_shift register left by 1, insert new data at LSB
                    pattern_shift <= {pattern_shift[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // don't-care; choose 0 for synthesis

                    if (pattern_detected) begin
                        delay_reg <= 4'b0;
                        load_bit_idx <= 2'd0;
                    end
                end

                LOAD: begin
                    // Shift left delay_reg, insert current data bit at LSB
                    delay_reg <= {delay_reg[2:0], data};
                    load_bit_idx <= load_bit_idx + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0; // don't-care

                    // pattern_shift not used in LOAD, freeze
                    // (Keep as is, no shift)

                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // update count output to blocks remaining minus 1 per spec
                    count <= block_count;

                    if (cycle_counter != 0) begin
                        cycle_counter <= cycle_counter - 1'b1;
                    end
                end

                WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0; // don't-care, set 0
                    // freeze pattern_shift so it won't detect new pattern before ack
                    // do not update pattern_shift
                end

                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                    pattern_shift <= 4'b0;
                    delay_reg <= 4'b0;
                    load_bit_idx <= 2'd0;
                    cycle_counter <= 16'd0;
                end
            endcase
        end
    end

    // Next-state logic combinational block
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_detected) begin
                    next_state = LOAD;
                end
            end

            LOAD: begin
                if (load_bit_idx == 2'd3) begin
                    next_state = COUNT;
                end
            end

            COUNT: begin
                if (cycle_counter == 16'd0) begin
                    next_state = WAIT_ACK;
                end
            end

            WAIT_ACK: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // At LOAD->COUNT transition, initialize cycle_counter with total_cycles
    always @(posedge clk) begin
        if (reset) begin
            cycle_counter <= 16'd0;
        end else begin
            if (state == LOAD && next_state == COUNT) begin
                // delay_reg is fully loaded this cycle with last bit shifted in
                // so delay_reg is ready to use here
                cycle_counter <= total_cycles;
            end
        end
    end

endmodule