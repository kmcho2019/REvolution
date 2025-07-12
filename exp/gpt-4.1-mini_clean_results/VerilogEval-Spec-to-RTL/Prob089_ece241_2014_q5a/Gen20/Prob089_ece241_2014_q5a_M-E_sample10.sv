module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic {NO_CARRY = 1'b0, CARRY = 1'b1} state_t;
    state_t state, next_state;

    // Next-state and output logic (Mealy FSM)
    always_comb begin
        case (state)
            NO_CARRY: begin
                // Output z is same as input x before first '1' seen
                z = x;
                if (x == 1'b1) begin
                    next_state = CARRY; // Found LSB 1, start inverting next bits
                end else begin
                    next_state = NO_CARRY;
                end
            end
            CARRY: begin
                // Output z is inverted input bits after LSB 1 encountered
                z = ~x;
                next_state = CARRY;
            end
            default: begin
                z = x;
                next_state = NO_CARRY;
            end
        endcase
    end

    // State register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= NO_CARRY;
        else
            state <= next_state;
    end

endmodule