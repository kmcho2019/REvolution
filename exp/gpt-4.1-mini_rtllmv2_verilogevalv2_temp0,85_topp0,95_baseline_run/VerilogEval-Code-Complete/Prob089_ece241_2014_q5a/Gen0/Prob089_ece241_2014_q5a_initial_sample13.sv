module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // States
    localparam S0 = 1'b0; // Before first '1' bit seen
    localparam S1 = 1'b1; // After first '1' bit seen

    reg state, next_state;

    // State register with asynchronous active-high reset
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

    // Output logic (Moore machine: output depends on state and input)
    always @(*) begin
        case (state)
            S0: z = x;       // Pass input bit until first '1'
            S1: z = ~x;      // After first '1', invert input bits
            default: z = 1'b0;
        endcase
    end

endmodule