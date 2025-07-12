module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding using localparam for readability
    localparam BEFORE_CARRY = 1'b0;
    localparam AFTER_CARRY  = 1'b1;

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
                default:      state <= BEFORE_CARRY;
            endcase
        end
    end

    // Asynchronous reset and input sampling block
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
        end
    end

    // Combinational Moore output logic: output depends on registered state and input
    always @(*) begin
        case (state)
            BEFORE_CARRY: z = x_reg;
            AFTER_CARRY:  z = ~x_reg;
            default:      z = 1'b0;
        endcase
    end

endmodule