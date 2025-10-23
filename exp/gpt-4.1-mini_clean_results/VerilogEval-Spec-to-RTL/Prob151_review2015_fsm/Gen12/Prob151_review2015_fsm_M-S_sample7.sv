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

    // FSM states
    localparam [1:0]
        SEARCH = 2'd0,  // search for pattern 1101
        SHIFT  = 2'd1,  // shift in 4 bits
        WAIT   = 2'd2;  // wait done_counting and ack

    reg [1:0] state, next_state;
    reg [1:0] shift_count;
    reg [3:0] pattern_shift;  // shift register to detect pattern

    // Sequential logic: pattern shift register and FSM registers
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            shift_count <= 2'd0;
            pattern_shift <= 4'd0;
        end else begin
            state <= next_state;

            if (state == SEARCH) begin
                // Shift in data to detect pattern
                pattern_shift <= {pattern_shift[2:0], data};
                shift_count <= 2'd0;
            end else if (state == SHIFT) begin
                // count 4 cycles of shift enable
                shift_count <= shift_count + 2'd1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = SHIFT;
                else
                    next_state = SEARCH;
            end

            SHIFT: begin
                if (shift_count == 2'd3)
                    next_state = WAIT;
                else
                    next_state = SHIFT;
            end

            WAIT: begin
                if (done_counting && ack)
                    next_state = SEARCH;
                else
                    next_state = WAIT;
            end

            default: next_state = SEARCH;
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting  = (state == WAIT) && !done_counting;
        done      = (state == WAIT) && done_counting;
    end

endmodule