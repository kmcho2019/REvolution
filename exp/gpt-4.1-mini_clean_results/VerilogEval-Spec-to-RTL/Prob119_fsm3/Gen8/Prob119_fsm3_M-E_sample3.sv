module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic with bitwise assignments for clarity
    always @(*) begin
        next_state = 4'b0000; // default no state

        if (state == A)
            next_state = (in == 1'b0) ? A : B;
        else if (state == B)
            next_state = (in == 1'b0) ? C : B;
        else if (state == C)
            next_state = (in == 1'b0) ? A : D;
        else if (state == D)
            next_state = (in == 1'b0) ? C : B;
        else
            next_state = A; // safety fallback
    end

    // Moore output: output is 1 only in state D
    assign out = state[3];

endmodule