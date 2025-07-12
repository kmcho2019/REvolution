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
    reg x_reg;

    // Asynchronous reset and sequential logic to register input and update state
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_CARRY;
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            case(state)
                BEFORE_CARRY: begin
                    if (x_reg == 1'b1)
                        state <= AFTER_CARRY;
                    else
                        state <= BEFORE_CARRY;
                end
                AFTER_CARRY: begin
                    state <= AFTER_CARRY; // stay after carry state
                end
                default: state <= BEFORE_CARRY;
            endcase
        end
    end

    // Moore output: depends only on registered state and input
    always @(*) begin
        case(state)
            BEFORE_CARRY: z = x_reg;
            AFTER_CARRY:  z = ~x_reg;
            default:      z = 1'b0;
        endcase
    end

endmodule