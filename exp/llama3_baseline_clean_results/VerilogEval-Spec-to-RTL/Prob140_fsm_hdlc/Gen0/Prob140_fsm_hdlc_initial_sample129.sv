module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define the states of the FSM
enum logic [3:0] {
    IDLE = 4'd0,
    ONE = 4'd1,
    TWO = 4'd2,
    THREE = 4'd3,
    FOUR = 4'd4,
    FIVE = 4'd5,
    DISCARD = 4'd6,
    FLAG = 4'd7,
    ERROR = 4'd8
} state, next_state;

// Current state register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= next_state;
        if (next_state == DISCARD) disc <= 1'b1;
        else disc <= 1'b0;
        if (next_state == FLAG) flag <= 1'b1;
        else flag <= 1'b0;
        if (next_state == ERROR) err <= 1'b1;
        else err <= 1'b0;
    end
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
            if (in) next_state = DISCARD;
            else next_state = IDLE;
        end
        DISCARD: begin
            if (in) next_state = ERROR;
            else next_state = IDLE;
        end
        FLAG: begin
            if (in) next_state = ERROR;
            else next_state = IDLE;
        end
        ERROR: begin
            if (!in) next_state = IDLE;
            else next_state = ERROR;
        end
        default: next_state = IDLE;
    endcase
end

endmodule