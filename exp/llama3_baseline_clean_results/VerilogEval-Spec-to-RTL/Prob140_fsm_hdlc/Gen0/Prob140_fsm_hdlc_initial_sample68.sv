module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Enumerate states
enum logic [2:0] {
    IDLE,  // Reset state
    ONE,   // Seen one 1
    TWO,   // Seen two 1s
    THREE, // Seen three 1s
    FOUR,  // Seen four 1s
    FIVE,  // Seen five 1s
    SIX,   // Seen six 1s (discard)
    SEVEN  // Seen seven 1s (error)
} state, next_state;

// Output registers
logic disc_reg, flag_reg, err_reg;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        state <= next_state;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
        case (state)
            SIX: disc_reg <= 1;
            SEVEN: err_reg <= 1;
            default: ;
        endcase
        if (in == 0) begin
            if (state == FIVE) begin
                // Transition from FIVE to IDLE (discard)
                next_state <= IDLE;
                disc_reg <= 1;
            end else if (state == SIX) begin
                // Transition from SIX to IDLE (flag)
                next_state <= IDLE;
                flag_reg <= 1;
            end else begin
                next_state <= IDLE;
            end
        end else begin
            case (state)
                IDLE: next_state <= ONE;
                ONE: next_state <= TWO;
                TWO: next_state <= THREE;
                THREE: next_state <= FOUR;
                FOUR: next_state <= FIVE;
                FIVE: next_state <= SIX;
                SIX: next_state <= SEVEN;
                SEVEN: next_state <= SEVEN;
                default: next_state <= IDLE;
            endcase
        end
    end
end

// Combinational logic
assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule