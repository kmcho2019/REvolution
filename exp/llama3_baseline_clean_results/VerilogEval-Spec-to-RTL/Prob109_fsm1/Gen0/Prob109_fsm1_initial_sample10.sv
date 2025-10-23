module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // Define states
    enum logic [0:0] {B, A} state, next_state;

    // Asynchronous reset
    always @(posedge clk or posedge areset)
    begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state logic
    always_comb
    begin
        case (state)
            B: next_state = (in) ? B : A;
            A: next_state = (in) ? A : B;
            default: next_state = B;
        endcase
    end

    // Output logic
    assign out = (state == A) ? 0 : 1;

endmodule