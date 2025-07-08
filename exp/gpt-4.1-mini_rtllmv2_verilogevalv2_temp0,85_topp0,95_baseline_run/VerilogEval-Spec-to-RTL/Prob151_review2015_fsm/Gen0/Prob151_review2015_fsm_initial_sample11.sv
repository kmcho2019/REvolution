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

    // FSM states
    typedef enum logic [1:0] {
        IDLE   = 2'd0,
        SHIFT  = 2'd1,
        COUNT  = 2'd2,
        DONE   = 2'd3
    } state_t;

    state_t state, next_state;

    reg [3:0] pattern_shift; // shift register to detect 1101 pattern
    reg [2:0] shift_count;   // count 4 shift cycles

    // Pattern to detect
    localparam [3:0] START_PATTERN = 4'b1101;

    // FSM sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift <= 4'b0000;
            shift_count <= 3'd0;
        end else begin
            state <= next_state;

            if (state == IDLE) begin
                // Shift in data to detect pattern
                pattern_shift <= {pattern_shift[2:0], data};
            end else begin
                pattern_shift <= pattern_shift; // hold in other states
            end

            if (state == SHIFT) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 3'd0;
            end
        end
    end

    // FSM combinational logic
    always @(*) begin
        // default outputs
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
        next_state = state;

        case(state)
            IDLE: begin
                // Check for pattern match
                if (pattern_shift == START_PATTERN) begin
                    next_state = SHIFT;
                end
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_count == 3'd3) begin // after 4 cycles (0..3)
                    next_state = COUNT;
                end
            end
            COUNT: begin
                counting = 1'b1;
                if (done_counting) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                done = 1'b1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule