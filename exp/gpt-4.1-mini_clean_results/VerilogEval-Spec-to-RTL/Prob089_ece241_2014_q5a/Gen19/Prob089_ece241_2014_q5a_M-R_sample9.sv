module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // One-hot state encoding
    localparam BEFORE_CARRY = 2'b01; // waiting for first '1'
    localparam AFTER_CARRY  = 2'b10; // inverting bits after carry

    reg [1:0] state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= BEFORE_CARRY;
        else
            state <= next_state;
    end

    // Next-state logic combinationally based on current state and input directly
    always @(*) begin
        case (state)
            BEFORE_CARRY: next_state = (x == 1'b1) ? AFTER_CARRY : BEFORE_CARRY;
            AFTER_CARRY:  next_state = AFTER_CARRY;
            default:      next_state = BEFORE_CARRY;
        endcase
    end

    // Moore output combinational using assign and state plus direct input
    assign z = (state == BEFORE_CARRY) ? x : 
               (state == AFTER_CARRY)  ? ~x : 1'b0;

endmodule