module TopModule (
    input             clk,
    input             reset,  // synchronous active-high reset
    input             data,
    output reg [3:0]  count,
    output reg        counting,
    output reg        done,
    input             ack
);

    // State encoding
    localparam IDLE       = 3'd0;
    localparam WAIT_DELAY = 3'd1;
    localparam COUNT      = 3'd2;
    localparam DONE       = 3'd3;
    localparam WAIT_ACK   = 3'd4;

    reg [2:0] state, next_state;

    // For detecting start pattern "1101"
    reg [3:0] pattern_reg;

    // Delay loading shift index [3:0], from MSB to LSB
    reg [2:0] delay_bit_index;
    reg [3:0] delay_reg;

    // Timing counters
    reg [9:0] cycle_counter; // counts 0..999 for 1000 cycles
    reg [3:0] tick_counter;  // counts down from delay to zero ticks

    // State transition combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_reg == 4'b1101)
                    next_state = WAIT_DELAY;
            end

            WAIT_DELAY: begin
                if (delay_bit_index == 3'd4)
                    next_state = COUNT;
            end

            COUNT: begin
                // When tick_counter reaches 0 and cycle_counter reaches 999, done counting
                if ((tick_counter == 0) && (cycle_counter == 10'd999))
                    next_state = DONE;
            end

            DONE: begin
                next_state = WAIT_ACK; // After done assertion, wait ack
            end

            WAIT_ACK: begin
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'd0;
            delay_reg <= 4'd0;
            delay_bit_index <= 3'd0;
            cycle_counter <= 10'd0;
            tick_counter <= 4'd0;
            count <= 4'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case (state)

                IDLE: begin
                    // Shift in data bit, left-shift pattern_reg, insert at LSB
                    pattern_reg <= {pattern_reg[2:0], data};
                    delay_reg <= 4'd0;
                    delay_bit_index <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                WAIT_DELAY: begin
                    // Hold pattern_reg (no update)
                    pattern_reg <= pattern_reg;

                    // Load delay_reg MSB-first: put data into delay_reg[3 - delay_bit_index]
                    // On each cycle, increment delay_bit_index
                    case (delay_bit_index)
                        3'd0: delay_reg[3] <= data;
                        3'd1: delay_reg[2] <= data;
                        3'd2: delay_reg[1] <= data;
                        3'd3: delay_reg[0] <= data;
                        default: ; // should not happen
                    endcase

                    delay_bit_index <= delay_bit_index + 1'b1;

                    // Outputs inactive
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;

                    // Reset counters for counting start
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                end

                COUNT: begin
                    // Hold pattern_reg
                    pattern_reg <= pattern_reg;
                    delay_reg <= delay_reg;
                    delay_bit_index <= delay_bit_index;

                    counting <= 1'b1;
                    done <= 1'b0;

                    // On first cycle entering COUNT, initialize tick_counter from delay_reg
                    // We detect entry by state==COUNT && previous state == WAIT_DELAY, but to avoid complex logic,
                    // initialize tick_counter when cycle_counter==0 and tick_counter==0
                    if (cycle_counter == 10'd0 && tick_counter == 4'd0) begin
                        tick_counter <= delay_reg;
                    end

                    // Output count = tick_counter while counting
                    count <= tick_counter;

                    // Increment cycle_counter
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        // If tick_counter > 0, decrement tick_counter at end of each 1000 cycle interval
                        if (tick_counter != 0) begin
                            tick_counter <= tick_counter - 1'b1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end
                end

                DONE: begin
                    // Hold pattern_reg
                    pattern_reg <= pattern_reg;
                    delay_reg <= delay_reg;
                    delay_bit_index <= delay_bit_index;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'd0;
                end

                WAIT_ACK: begin
                    // Hold pattern_reg etc.
                    pattern_reg <= pattern_reg;
                    delay_reg <= delay_reg;
                    delay_bit_index <= delay_bit_index;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'd0;
                end

                default: begin
                    state <= IDLE;
                    pattern_reg <= 4'd0;
                    delay_reg <= 4'd0;
                    delay_bit_index <= 3'd0;
                    cycle_counter <= 10'd0;
                    tick_counter <= 4'd0;
                    count <= 4'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule