module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Next state logic: 
    // From B(1): on 0 -> A(0), on 1 -> B(1)
    // From A(0): on 0 -> B(1), on 1 -> A(0)
    always @(*) begin
        case(state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
            default: next_state = B; // safe default
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output is current state (Moore)
    assign out = state;

endmodule