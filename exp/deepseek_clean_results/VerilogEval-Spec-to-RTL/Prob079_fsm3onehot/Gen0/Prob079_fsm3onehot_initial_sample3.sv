module TopModule (
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

    // State definitions (one-hot encoding)
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // Next state logic
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[0]: next_state = in ? B : A;      // State A
            state[1]: next_state = in ? B : C;      // State B
            state[2]: next_state = in ? D : A;      // State C
            state[3]: next_state = in ? B : C;      // State D
            default:  next_state = A;               // Default to A
        endcase
    end

    // Output logic (Moore: output depends only on current state)
    assign out = state[3]; // Output is 1 only in state D (MSB)

endmodule