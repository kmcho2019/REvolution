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

    // State encoding (2 bits sufficient)
    localparam SEARCH = 2'd0;
    localparam SHIFT  = 2'd1;
    localparam COUNT  = 2'd2;
    localparam DONE   = 2'd3;

    reg [1:0] state, next_state;

    // 4-bit shift register to detect pattern "1101"
    reg [3:0] pattern_shift;

    // 3-bit counter to count 4 shift cycles (0 to 3)
    reg [2:0] shift_counter, next_shift_counter;

    // Sequential logic: state, pattern_shift, shift_counter update
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern_shift <= 4'b0000;
            shift_counter <= 3'd0;
        end else begin
            state <= next_state;
            pattern_shift <= {pattern_shift[2:0], data};
            if (state == SHIFT)
                shift_counter <= next_shift_counter;
            else
                shift_counter <= 3'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        next_shift_counter = shift_counter + 3'd1;

        case(state)
            SEARCH: begin
                // Check if pattern_shift matches 1101
                if (pattern_shift == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            end

            SHIFT: begin
                if (shift_counter == 3'd3) // after 4 cycles
                    next_state = COUNT;
                else
                    next_state = SHIFT;
            end

            COUNT: begin
                if (done_counting)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end

            DONE: begin
                if (ack)
                    next_state = SEARCH;
                else
                    next_state = DONE;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting = (state == COUNT);
        done = (state == DONE);
    end

endmodule