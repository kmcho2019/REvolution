module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire data,
    output reg  [3:0] count,
    output reg  counting,
    output reg  done,
    input  wire ack
);

// States encoding
localparam IDLE       = 2'b00;
localparam DELAY_LOAD = 2'b01;
localparam COUNTING   = 2'b10;
localparam DONE       = 2'b11;

reg [1:0] state, next_state;

// Shift register for pattern detection (last 4 bits)
reg [3:0] pattern_shift;

// Delay bits register (4 bits)
reg [3:0] delay_reg;

// Bit counter for delay loading (0 to 4)
reg [2:0] delay_bit_count;

// 10-bit micro counter counts 0..999 clock cycles per step
reg [9:0] micro_counter;

// Step counter counts remaining delay steps (delay+1)
reg [4:0] step_counter; // 5 bits to cover max 16 steps

// Sequential state and registers update
always @(posedge clk) begin
    if (reset) begin
        state          <= IDLE;
        pattern_shift  <= 4'b0000;
        delay_reg      <= 4'b0000;
        delay_bit_count<= 3'd0;
        micro_counter  <= 10'd0;
        step_counter   <= 5'd0;
        count          <= 4'b0000;
        counting       <= 1'b0;
        done           <= 1'b0;
    end else begin
        state <= next_state;

        case(state)
            IDLE: begin
                // Shift in data to pattern_shift to detect pattern 1101
                pattern_shift <= {pattern_shift[2:0], data};
                delay_bit_count <= 3'd0;
                micro_counter <= 10'd0;
                step_counter <= 5'd0;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;
            end

            DELAY_LOAD: begin
                // Shift in delay bits MSB first
                delay_reg <= {delay_reg[2:0], data};
                delay_bit_count <= delay_bit_count + 1'b1;
                // Hold other signals
                pattern_shift <= pattern_shift;
                micro_counter <= 10'd0;
                step_counter <= 5'd0;
                counting <= 1'b0;
                done <= 1'b0;
                count <= 4'b0000;
            end

            COUNTING: begin
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                delay_bit_count <= delay_bit_count;

                counting <= 1'b1;
                done <= 1'b0;

                if (micro_counter == 10'd999) begin
                    micro_counter <= 10'd0;
                    if (step_counter != 0) begin
                        step_counter <= step_counter - 1'b1;
                    end
                end else begin
                    micro_counter <= micro_counter + 1'b1;
                end

                // Output count is current remaining steps - 1 during the micro_counter counting,
                // but stable during the 1000-cycle interval
                // Because step_counter counts down after micro_counter hits 999
                if (step_counter != 0) begin
                    if (micro_counter == 10'd999)
                        count <= (step_counter - 1'b1)[3:0];
                    else
                        count <= step_counter[3:0];
                end else begin
                    // When step_counter reaches 0, count = 0
                    count <= 4'b0000;
                end
            end

            DONE: begin
                // Hold outputs: done=1, counting=0, count don't care (set 0)
                done <= 1'b1;
                counting <= 1'b0;
                count <= 4'b0000;
                // Hold other registers
                pattern_shift <= pattern_shift;
                delay_reg <= delay_reg;
                delay_bit_count <= 3'd0;
                micro_counter <= 10'd0;
                step_counter <= 5'd0;
            end

            default: begin
                // Should never happen, reset defaults
                state <= IDLE;
                pattern_shift <= 4'b0000;
                delay_reg <= 4'b0000;
                delay_bit_count <= 3'd0;
                micro_counter <= 10'd0;
                step_counter <= 5'd0;
                count <= 4'b0000;
                counting <= 1'b0;
                done <= 1'b0;
            end
        endcase
    end
end

// Next state logic combinational
always @(*) begin
    next_state = state;
    case(state)
        IDLE: begin
            if (pattern_shift == 4'b1101) begin
                next_state = DELAY_LOAD;
            end else begin
                next_state = IDLE;
            end
        end

        DELAY_LOAD: begin
            if (delay_bit_count == 3'd4) begin
                next_state = COUNTING;
            end else begin
                next_state = DELAY_LOAD;
            end
        end

        COUNTING: begin
            // Transition to DONE when step_counter == 0 and micro_counter at end of cycle
            if ((step_counter == 0) && (micro_counter == 10'd999)) begin
                next_state = DONE;
            end else begin
                next_state = COUNTING;
            end
        end

        DONE: begin
            if (ack) begin
                next_state = IDLE;
            end else begin
                next_state = DONE;
            end
        end

        default: next_state = IDLE;
    endcase
end

// Initialize step_counter at COUNTING start
reg prev_state_was_delay_load;
always @(posedge clk) begin
    if (reset) begin
        prev_state_was_delay_load <= 1'b0;
    end else begin
        prev_state_was_delay_load <= (state == DELAY_LOAD);
    end
end

always @(posedge clk) begin
    if (reset) begin
        step_counter <= 5'd0;
        micro_counter <= 10'd0;
    end else begin
        // Load step_counter = delay_reg + 1 only on transition DELAY_LOAD -> COUNTING
        if ((prev_state_was_delay_load) && (state == COUNTING)) begin
            step_counter <= delay_reg + 1'b1;
            micro_counter <= 10'd0;
        end
    end
end

endmodule