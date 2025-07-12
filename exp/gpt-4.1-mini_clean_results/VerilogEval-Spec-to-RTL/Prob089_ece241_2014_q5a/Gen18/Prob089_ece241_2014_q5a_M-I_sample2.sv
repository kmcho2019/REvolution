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

    // Asynchronous reset and combined state update block
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_CARRY;
        end else begin
            case (state)
                BEFORE_CARRY: state <= (x == 1'b1) ? AFTER_CARRY : BEFORE_CARRY;
                AFTER_CARRY:  state <= AFTER_CARRY;
                default:      state <= BEFORE_CARRY;
            endcase
        end
    end

    // Combinational output logic based on current state and input x
    always @(*) begin
        case (state)
            BEFORE_CARRY: z = x;
            AFTER_CARRY:  z = ~x;
            default:      z = 1'b0;
        endcase
    end

endmodule