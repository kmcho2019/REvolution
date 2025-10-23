module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;       // current state: 0 = A, 1 = B
    reg next_state;  // next state

    // Combinational next state logic
    always @(*) begin
        case (state)
            1'b0: next_state = in ? 1'b0 : 1'b1; // A: 0->B if in=0 else stays A
            1'b1: next_state = in ? 1'b1 : 1'b0; // B: 1->B if in=1 else goes to A
            default: next_state = 1'b1; // default to B
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // reset to B
        else
            state <= next_state;
    end

    assign out = state;

endmodule