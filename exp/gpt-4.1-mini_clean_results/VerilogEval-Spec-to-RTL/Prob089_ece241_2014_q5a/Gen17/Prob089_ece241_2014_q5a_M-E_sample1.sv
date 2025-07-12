module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam BEFORE_CARRY = 1'b0; // waiting for first '1' (carry not started)
    localparam AFTER_CARRY  = 1'b1; // carry started, invert bits

    reg state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            BEFORE_CARRY: next_state = (x == 1'b1) ? AFTER_CARRY : BEFORE_CARRY;
            AFTER_CARRY:  next_state = AFTER_CARRY;
            default:      next_state = BEFORE_CARRY;
        endcase
    end

    // State and output register, asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_CARRY;
            z <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                BEFORE_CARRY: z <= x;       // pass bits until first '1'
                AFTER_CARRY:  z <= ~x;      // invert bits after first '1'
                default:     z <= 1'b0;
            endcase
        end
    end

endmodule