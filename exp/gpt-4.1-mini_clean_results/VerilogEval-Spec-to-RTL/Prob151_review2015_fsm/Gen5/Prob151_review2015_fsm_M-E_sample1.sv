module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE     = 3'd0,
        SHIFT    = 3'd1,
        COUNTING = 3'd2,
        DONE     = 3'd3
    } state_t;

    state_t state, next_state;

    // Shift register for pattern detection (4 bits)
    reg [3:0] pattern_shift_reg;

    // Counter for 4 shift cycles during SHIFT state
    reg [1:0] shift_count;

    // Constant pattern to detect: 1101
    localparam [3:0] PATTERN = 4'b1101;

    // Sequential logic: state update, pattern shift reg, and shift counter
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift_reg <= 4'b0000;
            shift_count <= 2'd0;
        end else begin
            // Shift in serial data every clock cycle for pattern detection
            pattern_shift_reg <= {pattern_shift_reg[2:0], data};

            // State transitions and internal counters
            state <= next_state;

            // Manage shift_count counter only in SHIFT state
            if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else begin
                shift_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case(state)
            IDLE: begin
                // Detect pattern immediately from shift register
                if (pattern_shift_reg == PATTERN)
                    next_state = SHIFT;
            end

            SHIFT: begin
                // After 4 shift cycles, move to COUNTING
                if (shift_count == 2'd3) // counts 0..3 for 4 cycles
                    next_state = COUNTING;
            end

            COUNTING: begin
                if (done_counting)
                    next_state = DONE;
            end

            DONE: begin
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore FSM)
    assign shift_ena = (state == SHIFT);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule