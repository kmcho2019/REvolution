module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    typedef enum logic {A, B} state_t;
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
            B: next_state = (in == 0) ? A : B;
            A: next_state = (in == 0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Output logic (Moore machine - output depends on state)
    always_comb begin
        case (state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1;
        endcase
    end

endmodule