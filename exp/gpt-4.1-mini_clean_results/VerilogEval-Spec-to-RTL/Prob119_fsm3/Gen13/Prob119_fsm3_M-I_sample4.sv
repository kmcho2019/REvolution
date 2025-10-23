module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding
    parameter A = 4'b0001,
              B = 4'b0010,
              C = 4'b0100,
              D = 4'b1000;

    reg [3:0] state, next_state;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic using one-hot encoding
    always @(*) begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Output logic: out=1 if in state D, else 0
    assign out = state[3];  // state D is bit 3 in one-hot encoding

endmodule