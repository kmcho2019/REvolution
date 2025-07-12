module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot encoding for states
    // 4 states represented as a 4-bit register with one-hot bits
    // A=0001, B=0010, C=0100, D=1000
    localparam [3:0] A = 4'b0001,
                     B = 4'b0010,
                     C = 4'b0100,
                     D = 4'b1000;

    reg [3:0] state, next_state;

    // Asynchronous reset and synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state logic
    always @(*) begin
        // Default to no change
        next_state = 4'b0000;
        case (1'b1)  // one-hot encoding case selection
            state[0]: // State A
                next_state = in ? B : A;
            state[1]: // State B
                next_state = in ? B : C;
            state[2]: // State C
                next_state = in ? D : A;
            state[3]: // State D
                next_state = in ? B : C;
            default:
                next_state = A; // safety fallback
        endcase
    end

    // Output: 1 only in state D (state[3] is D)
    assign out = state[3];

endmodule