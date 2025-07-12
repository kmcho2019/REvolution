module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input  ack
);

    // FSM states
    localparam IDLE       = 3'd0;
    localparam MATCH      = 3'd1;
    localparam READ_DELAY = 3'd2;
    localparam COUNT      = 3'd3;
    localparam DONE       = 3'd4;

    reg [2:0] state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay loading
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_received; // counts 0..3

    // Counting timer
    reg [9:0] cycle_counter;      // counts 0..999
    reg [4:0] block_count;        // counts down from delay+1 down to 0 (max 17)

    // Synchronous FSM and registers update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0;
            delay_reg <= 4'b0;
            delay_bits_received <= 3'd0;
            cycle_counter <= 10'd0;
            block_count <= 5'd0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    // Shift in data to pattern_shift
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_received <= 3'd0;
                    delay_reg <= 4'b0;
                    cycle_counter <= 10'd0;
                    block_count <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end

                MATCH: begin
                    // Pattern matched, stay here one cycle to prep delay reading
                    // pattern_shift unchanged, outputs unchanged
                    delay_bits_received <= 3'd0;
                    delay_reg <= 4'b0;
                    cycle_counter <= 10'd0;
                    block_count <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end

                READ_DELAY: begin
                    // Shift delay_reg left by 1 and input new bit at LSB (MSB first)
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_received <= delay_bits_received + 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    cycle_counter <= 10'd0;
                    block_count <= 5'd0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= block_count[3:0]; // lower 4 bits output

                    // cycle counter increment or reset
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (block_count != 5'd0)
                            block_count <= block_count - 1'b1;
                        else
                            block_count <= 5'd0; // Hold zero
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // pattern_shift and delay_bits_received unchanged here
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;
                    // Hold registers stable until ack received
                end

                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Pattern is detected when pattern_shift == 1101
                if (pattern_shift == 4'b1101) begin
                    next_state = MATCH;
                end
            end

            MATCH: begin
                // Immediately start reading delay bits next cycle
                next_state = READ_DELAY;
            end

            READ_DELAY: begin
                if (delay_bits_received == 3'd3) begin
                    next_state = COUNT;
                end
            end

            COUNT: begin
                // Done when finished last 1000-cycle block (block_count=0 and cycle_counter=999)
                if ((block_count == 5'd0) && (cycle_counter == 10'd999)) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                // Wait for ack signal
                if (ack) begin
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // On state transition to COUNT, initialize block_count = delay_reg + 1
    always @(posedge clk) begin
        if (!reset) begin
            if ((state == READ_DELAY) && (delay_bits_received == 3'd3)) begin
                // This is last cycle of READ_DELAY; setup block_count next cycle
                // So assign block_count in the next cycle when state changes to COUNT
                // Use a register to hold this init value or assign in synchronous block on state change
            end
            if ((state != COUNT) && (next_state == COUNT)) begin
                // Transition into COUNT state, initialize block_count and counters
                block_count <= {1'b0, delay_reg} + 5'd1; // delay + 1, zero extended to 5 bits
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule