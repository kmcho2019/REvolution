module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    localparam A = 1'b0, B = 1'b1;
    reg state;
    reg next_state;

    // Next state logic
    always @(*) begin
        case (state)
            B: next_state = in ? B : A;
            A: next_state = in ? A : B;
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

    // Output logic (Moore machine: output depends only on state)
    always @(*) begin
        out = state;
    end

endmodule