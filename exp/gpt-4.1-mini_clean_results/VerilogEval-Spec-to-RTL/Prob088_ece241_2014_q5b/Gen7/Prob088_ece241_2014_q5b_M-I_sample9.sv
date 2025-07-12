module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding: A = 0, B = 1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            A: next_state = x ? B : A;
            B: next_state = B;  // stays in B regardless of x
            default: next_state = A;
        endcase
    end

    // Output logic (Mealy)
    // From truth table:
    // State A: z = x
    // State B: z = ~x
    always @(*) begin
        z = (state == A) ? x : ~x;
    end

endmodule