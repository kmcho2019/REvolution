module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

    // One-hot encoded states
    localparam SEARCH = 5'b00001; // Searching pattern 1101
    localparam SHIFT  = 5'b00010; // Shifting in 4 bits
    localparam COUNT  = 5'b00100; // Counting delay
    localparam DONE_S = 5'b01000; // Done, waiting ack

    reg [4:0] state, next_state;

    // Shift register to detect pattern 1101 on serial data input
    reg [3:0] pattern_shift_reg, pattern_shift_reg_next;

    // 3-bit counter for shift cycles (counts 0..3)
    reg [2:0] shift_counter, shift_counter_next;

    // Pattern to detect
    localparam [3:0] PATTERN = 4'b1101;

    // Next state logic
    always @(*) begin
        next_state = state;
        pattern_shift_reg_next = pattern_shift_reg;
        shift_counter_next = shift_counter;

        case (state)
            SEARCH: begin
                // Shift in new data bit
                pattern_shift_reg_next = {pattern_shift_reg[2:0], data};
                // Check if pattern matches 1101
                if (pattern_shift_reg_next == PATTERN)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
                // Reset shift counter in SEARCH
                shift_counter_next = 3'd0;
            end

            SHIFT: begin
                // Increment shift counter each cycle
                if (shift_counter == 3'd3)
                    next_state = COUNT;
                else
                    next_state = SHIFT;

                // shift_counter increments only in SHIFT
                shift_counter_next = shift_counter + 3'd1;

                // pattern_shift_reg not relevant here; keep as is
                pattern_shift_reg_next = pattern_shift_reg;
            end

            COUNT: begin
                // Wait for done_counting to go high
                if (done_counting)
                    next_state = DONE_S;
                else
                    next_state = COUNT;
                // Reset shift_counter unused in COUNT
                shift_counter_next = 3'd0;
                pattern_shift_reg_next = pattern_shift_reg;
            end

            DONE_S: begin
                // Wait for ack to return to SEARCH
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE_S;
                // Reset shift_counter unused in DONE
                shift_counter_next = 3'd0;
                pattern_shift_reg_next = pattern_shift_reg;
            end

            default: begin
                next_state = SEARCH;
                pattern_shift_reg_next = 4'd0;
                shift_counter_next = 3'd0;
            end
        endcase
    end

    // Sequential logic for state, pattern shift register, shift_counter
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift_reg <= 4'b0000;
            shift_counter <= 3'd0;
        end else begin
            state <= next_state;
            pattern_shift_reg <= pattern_shift_reg_next;
            shift_counter <= shift_counter_next;
        end
    end

    // Moore output logic based on state
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == COUNT);
        done      = (state == DONE_S);
    end

endmodule