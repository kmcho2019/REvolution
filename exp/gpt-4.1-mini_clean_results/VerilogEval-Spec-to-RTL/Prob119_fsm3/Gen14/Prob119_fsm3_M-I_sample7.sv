module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot state encoding for 4 states
    // state bits: [D, C, B, A]
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with asynchronous reset to state A
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic using one-hot encoding
    always @(*) begin
        case (1'b1) // one-hot decode current state
            state[0]: // A
                next_state = in ? B : A;
            state[1]: // B
                next_state = in ? B : C;
            state[2]: // C
                next_state = in ? D : A;
            state[3]: // D
                next_state = in ? B : C;
            default:
                next_state = A; // safety reset state
        endcase
    end

    // Output logic: output = 1 if in state D, else 0
    assign out = state[3];

endmodule