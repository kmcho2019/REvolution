module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {S0 = 1'b0, S1 = 1'b1} state_t;
    state_t state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: begin
                if (x == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore machine output: depends only on state)
    always @(*) begin
        case (state)
            S0: z = x;       // before first '1', output = input bit
            S1: z = ~x;      // after first '1', output = inverted input bit
            default: z = 1'b0;
        endcase
    end

endmodule