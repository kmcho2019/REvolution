module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            B: next_state = in ? B : A;  // From B: if in=1 stay B, else A
            A: next_state = in ? A : B;  // From A: if in=1 stay A, else B
            default: next_state = B;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output logic (Moore machine output depends only on state)
    always @(*) begin
        case (state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1;
        endcase
    end

endmodule