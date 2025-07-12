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
            state[A]: next_state = in ? B : A;
            state[B]: next_state = in ? B : C;
            state[C]: next_state = in ? D : A;
            state[D]: next_state = in ? B : C;
            default: next_state = A; // Default to state A
        endcase
    end

    // Output logic (Moore machine: output depends only on state)
    assign out = (state == D);

endmodule