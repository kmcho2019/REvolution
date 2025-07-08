module TopModule(
    input  clk,
    input  areset, // active high asynchronous reset
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {
        BEFORE_CARRY = 1'b0,
        AFTER_CARRY  = 1'b1
    } state_t;

    state_t state, next_state;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_CARRY;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            BEFORE_CARRY: begin
                if (x == 1'b1)
                    next_state = AFTER_CARRY;
                else
                    next_state = BEFORE_CARRY;
            end
            AFTER_CARRY: begin
                next_state = AFTER_CARRY;
            end
            default: next_state = BEFORE_CARRY;
        endcase
    end

    // Output logic (Moore: depends only on state and input x as needed for output)
    always @(*) begin
        case (state)
            BEFORE_CARRY: z = x;       // output input bit directly until first '1'
            AFTER_CARRY:  z = ~x;      // output inverted bits after first '1'
            default:      z = 1'b0;
        endcase
    end

endmodule