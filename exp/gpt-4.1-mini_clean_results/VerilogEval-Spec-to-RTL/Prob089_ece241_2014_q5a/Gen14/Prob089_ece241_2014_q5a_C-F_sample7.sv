module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam BEFORE_CARRY = 1'b0; // Waiting for the first '1' (carry start)
    localparam AFTER_CARRY  = 1'b1; // Invert bits after carry starts

    reg state;
    reg x_reg;

    // Input sampling block: register input with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
        end
    end

    // State update block: asynchronous reset, update state on clock using sampled input
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_CARRY;
        end else begin
            case (state)
                BEFORE_CARRY: state <= (x_reg == 1'b1) ? AFTER_CARRY : BEFORE_CARRY;
                AFTER_CARRY:  state <= AFTER_CARRY;
                default:      state <= BEFORE_CARRY;
            endcase
        end
    end

    // Combinational output logic based on registered input and current state (Moore FSM)
    always @(*) begin
        case (state)
            BEFORE_CARRY: z = x_reg;    // Pass input bit as output until first '1' is found
            AFTER_CARRY:  z = ~x_reg;   // Invert input bits after first '1' detected
            default:     z = 1'b0;
        endcase
    end

endmodule