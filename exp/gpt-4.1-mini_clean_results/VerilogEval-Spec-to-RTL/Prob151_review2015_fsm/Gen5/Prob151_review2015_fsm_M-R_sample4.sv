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

    // State encoding (3 bits, one-hot not mandatory)
    typedef enum logic [2:0] {
        SEARCH   = 3'd0,
        SHIFT_0  = 3'd1,
        SHIFT_1  = 3'd2,
        SHIFT_2  = 3'd3,
        SHIFT_3  = 3'd4,
        COUNTING = 3'd5,
        DONE     = 3'd6
    } state_t;

    state_t state, next_state;

    // 4-bit pattern shift register (detects 1101)
    reg [3:0] pattern_reg;

    // Update pattern_reg every clock cycle except reset clears it
    always @(posedge clk) begin
        if (reset)
            pattern_reg <= 4'b0;
        else
            pattern_reg <= {pattern_reg[2:0], data};
    end

    // Synchronous state transition
    always @(posedge clk) begin
        if (reset)
            state <= SEARCH;
        else
            state <= next_state;
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            SEARCH:  next_state = (pattern_reg == 4'b1101) ? SHIFT_0 : SEARCH;
            SHIFT_0: next_state = SHIFT_1;
            SHIFT_1: next_state = SHIFT_2;
            SHIFT_2: next_state = SHIFT_3;
            SHIFT_3: next_state = COUNTING;
            COUNTING: next_state = done_counting ? DONE : COUNTING;
            DONE:    next_state = ack ? SEARCH : DONE;
            default: next_state = SEARCH;
        endcase
    end

    // Mealy outputs combinational, depend only on current state (and inputs if needed)
    assign shift_ena = (state == SHIFT_0) || (state == SHIFT_1) || (state == SHIFT_2) || (state == SHIFT_3);
    assign counting  = (state == COUNTING);
    assign done      = (state == DONE);

endmodule