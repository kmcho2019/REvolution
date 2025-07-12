module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);
    // State encoding
    typedef enum logic [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        case(state)
            A: next_state = (in == 0) ? A : B;
            B: next_state = (in == 0) ? C : B;
            C: next_state = (in == 0) ? A : D;
            D: next_state = (in == 0) ? C : B;
            default: next_state = A; // default to A for safety
        endcase
    end

    // State register with asynchronous active high reset
    always @(posedge clk or posedge areset) begin
        if(areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic (Moore output)
    always @(*) begin
        case(state)
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
endmodule