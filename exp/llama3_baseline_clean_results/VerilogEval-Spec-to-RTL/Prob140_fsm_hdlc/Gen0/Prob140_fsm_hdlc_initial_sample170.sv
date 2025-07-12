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
    TWO_TO_FIVE = 3'b010,
    SIX = 3'b011,
    DISCARD = 3'b100,
    FLAG = 3'b101,
    ERROR = 3'b110
} state, next_state;

// Output logic
assign disc = (state == DISCARD);
assign flag = (state == FLAG);
assign err = (state == ERROR);

// FSM logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

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
                next_state = TWO_TO_FIVE;
            end else begin
                next_state = IDLE;
            end
        end
        TWO_TO_FIVE: begin
            if (in) begin
                next_state = (state == TWO_TO_FIVE) ? SIX : TWO_TO_FIVE;
            end else begin
                next_state = IDLE;
            end
        end
        SIX: begin
            if (in) begin
                next_state = DISCARD;
            end else begin
                next_state = FLAG;
            end
        end
        DISCARD: begin
            if (in) begin
                next_state = ERROR;
            end else begin
                next_state = IDLE;
            end
        end
        FLAG: begin
            next_state = IDLE;
        end
        ERROR: begin
            if (~in) begin
                next_state = IDLE;
            end else begin
                next_state = ERROR;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule