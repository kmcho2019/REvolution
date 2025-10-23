module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State encoding
    localparam IDLE     = 2'd0;
    localparam SHIFT    = 2'd1;
    localparam COUNTING = 2'd2;
    localparam DONE     = 2'd3;

    reg [1:0] state, next_state;

    // Separate 4-bit shift register for pattern detection (always shifting in data)
    reg [3:0] pattern_shift;

    // Signal that pattern 1101 was detected on the last clock
    wire pattern_matched = (pattern_shift == 4'b1101);

    // Counter to track shift cycles (0 to 3) when in SHIFT state
    reg [1:0] shift_count;

    // Sequential logic: pattern shift register updates every clock
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'b0000;
        end else begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // FSM sequential state and counters update
    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            shift_count <= 2'd0;
        end else begin
            state <= next_state;

            if (state == SHIFT)
                shift_count <= shift_count + 1'b1;
            else
                shift_count <= 2'd0;
        end
    end

    // FSM combinational next state logic and output assignment
    always @(*) begin
        // Defaults
        next_state = state;
        shift_ena  = 1'b0;
        counting   = 1'b0;
        done       = 1'b0;

        case(state)
            IDLE: begin
                // Wait until pattern detected to start shifting
                if (pattern_matched)
                    next_state = SHIFT;
            end

            SHIFT: begin
                // Enable shifting for exactly 4 clock cycles: count 0..3
                shift_ena = 1'b1;
                if (shift_count == 2'd3)
                    next_state = COUNTING;
            end

            COUNTING: begin
                counting = 1'b1;
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                done = 1'b1;
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule