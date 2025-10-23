module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

    // One-hot state encoding
    localparam IDLE    = 6'b000001,
               SHIFT1  = 6'b000010,
               SHIFT2  = 6'b000100,
               SHIFT3  = 6'b001000,
               SHIFT4  = 6'b010000,
               COUNT   = 6'b100000,
               DONE    = 6'b1000000; // Actually 7 bits; correct below

    // Since 7 states, use 7 bits for one-hot states
    localparam [6:0] S_IDLE   = 7'b0000001,
                     S_SHIFT1 = 7'b0000010,
                     S_SHIFT2 = 7'b0000100,
                     S_SHIFT3 = 7'b0001000,
                     S_SHIFT4 = 7'b0010000,
                     S_COUNT  = 7'b0100000,
                     S_DONE   = 7'b1000000;

    reg [6:0] state, next_state;

    // 4-bit shift register for pattern detection, only updated in IDLE
    reg [3:0] pattern_reg;

    // Pattern to detect: 1101
    localparam [3:0] PATTERN = 4'b1101;

    // Synchronous state and pattern register update
    always @(posedge clk) begin
        if (reset) begin
            state       <= S_IDLE;
            pattern_reg <= 4'b0000;
        end else begin
            state <= next_state;
            if (state == S_IDLE)
                pattern_reg <= {pattern_reg[2:0], data};
            else
                pattern_reg <= pattern_reg; // Hold pattern_reg outside IDLE
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            S_IDLE: begin
                if (pattern_reg == PATTERN)
                    next_state = S_SHIFT1;
                else
                    next_state = S_IDLE;
            end

            S_SHIFT1: next_state = S_SHIFT2;
            S_SHIFT2: next_state = S_SHIFT3;
            S_SHIFT3: next_state = S_SHIFT4;
            S_SHIFT4: next_state = S_COUNT;

            S_COUNT: begin
                if (done_counting)
                    next_state = S_DONE;
                else
                    next_state = S_COUNT;
            end

            S_DONE: begin
                if (ack)
                    next_state = S_IDLE;
                else
                    next_state = S_DONE;
            end

            default: next_state = S_IDLE;
        endcase
    end

    // Outputs combinationally assigned from state (one-hot)
    assign shift_ena = (state == S_SHIFT1) ||
                       (state == S_SHIFT2) ||
                       (state == S_SHIFT3) ||
                       (state == S_SHIFT4);

    assign counting = (state == S_COUNT);
    assign done     = (state == S_DONE);

endmodule