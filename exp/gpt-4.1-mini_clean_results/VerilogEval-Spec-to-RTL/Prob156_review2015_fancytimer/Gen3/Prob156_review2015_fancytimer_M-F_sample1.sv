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
    localparam IDLE       = 2'd0;
    localparam READ_DELAY = 2'd1;
    localparam COUNT      = 2'd2;
    localparam DONE       = 2'd3;

    reg [1:0] state, next_state;

    // Pattern detection shift register (4 bits)
    reg [3:0] pattern_shift;

    // Delay loading
    reg [3:0] delay_reg;
    reg [2:0] delay_bits_received; // counts 0..3

    // Counting timer
    reg [9:0] cycle_counter;      // counts 0..999
    reg [4:0] block_count;        // counts down from delay+1 down to 0

    // FSM and registers update (synchronous, positive edge, active high reset)
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
                    // Shift in input bit to pattern_shift every cycle
                    pattern_shift <= {pattern_shift[2:0], data};
                    delay_bits_received <= 3'd0;
                    delay_reg <= 4'b0;
                    cycle_counter <= 10'd0;
                    block_count <= 5'd0;
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end

                READ_DELAY: begin
                    // Shift delay_reg left and input new bit at LSB (MSB first)
                    delay_reg <= {delay_reg[2:0], data};
                    delay_bits_received <= delay_bits_received + 1'b1;

                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    // pattern_shift unchanged here
                    cycle_counter <= 10'd0;
                    block_count <= 5'd0;
                end

                COUNT: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    count <= block_count[3:0];

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'd0;
                        if (block_count != 5'd0)
                            block_count <= block_count - 1'b1;
                        else
                            block_count <= 5'd0; // hold zero when done
                    end else begin
                        cycle_counter <= cycle_counter + 1'b1;
                    end

                    // Other regs unchanged
                    pattern_shift <= pattern_shift;
                    delay_bits_received <= delay_bits_received;
                    delay_reg <= delay_reg;
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'b0;

                    // Hold all other registers stable
                    pattern_shift <= pattern_shift;
                    delay_bits_received <= delay_bits_received;
                    delay_reg <= delay_reg;
                    cycle_counter <= cycle_counter;
                    block_count <= block_count;
                end

                default: begin
                    // Should not occur, safe reset outputs
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (pattern_shift == 4'b1101) begin
                    next_state = READ_DELAY;
                end
            end

            READ_DELAY: begin
                if (delay_bits_received == 3'd3) begin
                    // After receiving last delay bit, start counting next cycle
                    next_state = COUNT;
                end
            end

            COUNT: begin
                // Done after last 1000-cycle block counted
                if ((block_count == 5'd0) && (cycle_counter == 10'd999)) begin
                    next_state = DONE;
                end
            end

            DONE: begin
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // Initialize block_count and cycle_counter at transition into COUNT
    always @(posedge clk) begin
        if (!reset) begin
            if ((state == READ_DELAY) && (next_state == COUNT)) begin
                // Initialize block_count as delay_reg + 1
                block_count <= {1'b0, delay_reg} + 5'd1;
                cycle_counter <= 10'd0;
            end
        end
    end

endmodule