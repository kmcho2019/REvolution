module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam BEFORE_CARRY = 1'b0; // waiting for first '1' (carry-in)
    localparam AFTER_CARRY  = 1'b1; // inverting bits after carry starts

    reg state;
    reg x_reg;
    reg next_state;

    // Sequential block: sample input and update state with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_CARRY;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
        end
    end

    // Combinational block: next-state logic depends on current state and sampled input
    always @(*) begin
        case (state)
            BEFORE_CARRY: next_state = (x_reg == 1'b1) ? AFTER_CARRY : BEFORE_CARRY;
            AFTER_CARRY:  next_state = AFTER_CARRY;
            default:      next_state = BEFORE_CARRY;
        endcase
    end

    // Combinational output logic (Moore output) depends on current state and sampled input
    always @(*) begin
        case (state)
            BEFORE_CARRY: z = x_reg;
            AFTER_CARRY:  z = ~x_reg;
            default:      z = 1'b0;
        endcase
    end

endmodule