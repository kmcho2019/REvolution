module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

// Define states
enum logic [2:0] {
    IDLE = 3'b000,
    ONE = 3'b001,
    TWO = 3'b010,
    THREE = 3'b011,
    FOUR = 3'b100,
    FIVE = 3'b101,
    SIX = 3'b110,
    ERROR = 3'b111
} state, next_state;

// Output logic
always_comb begin
    disc = 0;
    flag = 0;
    err = 0;
    case (state)
        SIX: disc = 1;
        FIVE: flag = 1;
        ERROR: err = 1;
    endcase
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (in) next_state = ONE;
            else next_state = IDLE;
        end
        ONE: begin
            if (in) next_state = TWO;
            else next_state = IDLE;
        end
        TWO: begin
            if (in) next_state = THREE;
            else next_state = IDLE;
        end
        THREE: begin
            if (in) next_state = FOUR;
            else next_state = IDLE;
        end
        FOUR: begin
            if (in) next_state = FIVE;
            else next_state = IDLE;
        end
        FIVE: begin
            if (in) next_state = SIX;
            else next_state = IDLE;
        end
        SIX: begin
            if (in) next_state = ERROR;
            else next_state = IDLE;
        end
        ERROR: begin
            if (~in) next_state = IDLE;
            else next_state = ERROR;
        end
    endcase
end

// State register
always_ff @(posedge clk or posedge reset) begin
    if (reset) state <= IDLE;
    else state <= next_state;
end

endmodule