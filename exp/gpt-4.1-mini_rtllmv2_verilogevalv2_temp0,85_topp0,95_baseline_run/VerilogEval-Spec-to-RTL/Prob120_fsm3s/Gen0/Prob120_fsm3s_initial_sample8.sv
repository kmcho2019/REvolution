module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // Define states as parameters for readability
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11
    } state_t;

    state_t state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic combinational block
    always @(*) begin
        case(state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A;
        endcase
    end

    // Output logic for Moore FSM (based only on current state)
    always @(*) begin
        case(state)
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule