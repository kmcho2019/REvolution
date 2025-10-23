module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding for Moore FSM
    localparam BEFORE_CARRY = 1'b0;
    localparam AFTER_CARRY  = 1'b1;

    reg state;
    reg x_reg;

    // Input sampling register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // FSM state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= BEFORE_CARRY;
        else begin
            case(state)
                BEFORE_CARRY: state <= (x_reg == 1'b1) ? AFTER_CARRY : BEFORE_CARRY;
                AFTER_CARRY:  state <= AFTER_CARRY;
                default:      state <= BEFORE_CARRY;
            endcase
        end
    end

    // Moore output logic: depends only on registered state and x_reg
    always @(*) begin
        case(state)
            BEFORE_CARRY: z = x_reg;
            AFTER_CARRY:  z = ~x_reg;
            default:      z = 1'b0;
        endcase
    end

endmodule