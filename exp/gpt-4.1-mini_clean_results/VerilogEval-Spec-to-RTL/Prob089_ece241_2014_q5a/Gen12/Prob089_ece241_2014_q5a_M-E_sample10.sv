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

    // Asynchronous reset and state update block
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_CARRY;
        end else begin
            case (state)
                BEFORE_CARRY: state <= (x_reg == 1'b1) ? AFTER_CARRY : BEFORE_CARRY;
                AFTER_CARRY:  state <= AFTER_CARRY;
                default:     state <= BEFORE_CARRY;
            endcase
        end
    end

    // Input sampling block, synchronous with clk, async reset for input register as well
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
        end
    end

    // Combinational output logic block based on current state and sampled input
    always @(*) begin
        case (state)
            BEFORE_CARRY: z = x_reg;
            AFTER_CARRY:  z = ~x_reg;
            default:     z = 1'b0;
        endcase
    end

endmodule