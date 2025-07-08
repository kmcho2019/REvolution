module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    typedef enum logic {
        B = 1'b0,
        A = 1'b1
    } state_t;

    state_t state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // default to reset state
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        case(state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1;
        endcase
    end

endmodule