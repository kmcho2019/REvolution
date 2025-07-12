module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding: 4 states, 4 bits
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic with one-hot encoding
    always @(*) begin
        // Default next state to A for safety
        next_state = 4'b0000;
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Output logic: out=1 if in state D, else 0 (Moore output)
    always @(*) begin
        out = (state == D);
    end

endmodule