module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define the states as enumeration values
enum logic [2:0] {
    IDLE,
    ONE,
    TWO,
    THREE,
    FOUR,
    FIVE,
    FLAG,
    ERR,
    DISCARD
} state, next_state;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        IDLE: begin
            if (in) begin
                next_state = ONE;
            end else begin
                next_state = IDLE;
            end
        end
        ONE: begin
            if (in) begin
                next_state = TWO;
            end else begin
                next_state = IDLE;
            end
        end
        TWO: begin
            if (in) begin
                next_state = THREE;
            end else begin
                next_state = IDLE;
            end
        end
        THREE: begin
            if (in) begin
                next_state = FOUR;
            end else begin
                next_state = IDLE;
            end
        end
        FOUR: begin
            if (in) begin
                next_state = FIVE;
            end else begin
                next_state = IDLE;
            end
        end
        FIVE: begin
            if (in) begin
                next_state = DISCARD;
            end else begin
                next_state = IDLE;
            end
        end
        DISCARD: begin
            if (in) begin
                next_state = ERR;
            end else begin
                next_state = FLAG;
            end
        end
        FLAG: begin
            next_state = IDLE;
        end
        ERR: begin
            if (~in) begin
                next_state = IDLE;
            end else begin
                next_state = ERR;
            end
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
assign disc = (state == DISCARD);
assign flag = (state == FLAG);
assign err = (state == ERR);

endmodule