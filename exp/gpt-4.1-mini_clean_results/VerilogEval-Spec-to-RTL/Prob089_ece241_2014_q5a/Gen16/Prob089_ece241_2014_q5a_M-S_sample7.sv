module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    localparam BEFORE_CARRY = 1'b0;
    localparam AFTER_CARRY  = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_CARRY;
        end else begin
            if (state == BEFORE_CARRY && x == 1'b1)
                state <= AFTER_CARRY;
            else
                state <= state;
        end
    end

    always @(*) begin
        case (state)
            BEFORE_CARRY: z = x;
            AFTER_CARRY:  z = ~x;
            default:      z = 1'b0;
        endcase
    end

endmodule