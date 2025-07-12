module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam BEFORE_CARRY = 1'b0;
    localparam AFTER_CARRY  = 1'b1;

    reg state, next_state;
    reg x_reg;

    // Register input bit with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= BEFORE_CARRY;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            BEFORE_CARRY:
                if (x_reg == 1'b1)
                    next_state = AFTER_CARRY;
                else
                    next_state = BEFORE_CARRY;
            AFTER_CARRY:
                next_state = AFTER_CARRY;
            default:
                next_state = BEFORE_CARRY;
        endcase
    end

    // Moore output register logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            z <= 1'b0;
        else begin
            case(state)
                BEFORE_CARRY: z <= x_reg;
                AFTER_CARRY:  z <= ~x_reg;
                default:      z <= 1'b0;
            endcase
        end
    end

endmodule