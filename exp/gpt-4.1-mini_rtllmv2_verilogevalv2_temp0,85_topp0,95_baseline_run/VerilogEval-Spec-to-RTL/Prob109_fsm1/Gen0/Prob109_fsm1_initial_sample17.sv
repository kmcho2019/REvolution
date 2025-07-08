module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding
    typedef enum logic {
        A = 1'b0,
        B = 1'b1
    } state_t;

    state_t state, next_state;

    // State register with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // safety default
        endcase
    end

    // Output logic (Moore)
    always_comb begin
        case (state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1;
        endcase
    end

endmodule