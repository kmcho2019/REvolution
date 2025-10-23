module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // Enumerated states for clarity
    typedef enum reg {A = 1'b0, B = 1'b1} state_t;

    state_t state, next_state;

    // Next state logic combinational block
    always @(*) begin
        case(state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // default to reset state for safety
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output logic from state (Moore machine)
    always @(*) begin
        case(state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1;
        endcase
    end

endmodule