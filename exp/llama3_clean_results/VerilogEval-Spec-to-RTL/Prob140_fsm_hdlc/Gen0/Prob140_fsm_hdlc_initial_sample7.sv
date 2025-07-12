module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define the states
enum logic [2:0] {
    IDLE,
    ONE,
    TWO_ONES,
    THREE_ONES,
    FOUR_ONES,
    FIVE_ONES,
    FLAG
} state, next_state;

// Output logic
always_comb begin
    disc = 1'b0;
    flag = 1'b0;
    err = 1'b0;
    
    case (state)
        FIVE_ONES: if (~in) disc = 1'b1;
        FLAG: flag = 1'b1;
        default: if (state == FOUR_ONES && in && in) err = 1'b1;
    endcase
end

// Next state logic
always_comb begin
    next_state = state;
    
    case (state)
        IDLE: if (in) next_state = ONE;
        ONE: if (in) next_state = TWO_ONES; else next_state = IDLE;
        TWO_ONES: if (in) next_state = THREE_ONES; else next_state = IDLE;
        THREE_ONES: if (in) next_state = FOUR_ONES; else next_state = IDLE;
        FOUR_ONES: if (in) next_state = FIVE_ONES; else next_state = IDLE;
        FIVE_ONES: if (in) next_state = FLAG; else next_state = IDLE;
        FLAG: if (~in) next_state = IDLE; else next_state = FLAG;
        default: next_state = IDLE;
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule