module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    typedef enum logic [1:0] {A=2'b00, B=2'b01, C=2'b10, D=2'b11} state_t;

    state_t state, next_state;

    // Next state logic: combinational with case statement
    always @(*) begin
        case (state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output: 1 only in state D
    assign out = (state == D);

endmodule