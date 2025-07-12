module TopModule(
    input  clk,
    input  areset, // Changed to synchronous reset
    input  in,
    output out
);

    // One-hot state encoding
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        // Default next state to current state to avoid latches
        next_state = A;
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Output is high only when in state D
    assign out = state[3];

endmodule