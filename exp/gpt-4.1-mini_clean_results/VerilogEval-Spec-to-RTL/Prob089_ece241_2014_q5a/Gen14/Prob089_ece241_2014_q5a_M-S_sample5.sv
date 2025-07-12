module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam BEFORE_CARRY = 1'b0;
    localparam AFTER_CARRY  = 1'b1;

    reg state;

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_CARRY;
        end else begin
            case (state)
                BEFORE_CARRY: state <= (x == 1'b1) ? AFTER_CARRY : BEFORE_CARRY;
                AFTER_CARRY:  state <= AFTER_CARRY;
            endcase
        end
    end

    // Output logic combinationally from current state and input
    always @(*) begin
        case (state)
            BEFORE_CARRY: z = x;
            AFTER_CARRY:  z = ~x;
            default:     z = 1'b0;
        endcase
    end

endmodule