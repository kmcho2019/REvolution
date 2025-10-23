module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;     // 0 = A, 1 = B
    reg next_state;

    // Next state combinational logic explicitly described
    always @(*) begin
        case (state)
            1'b0: next_state = (in) ? 1'b0 : 1'b1;  // A: 0 on input 1->A(0), 0 on input 0->B(1)
            1'b1: next_state = (in) ? 1'b1 : 1'b0;  // B: 1 on input 1->B(1), 0 on input 0->A(0)
            default: next_state = 1'b1; // Default to B on unknown state
        endcase
    end

    // State register with asynchronous reset to B (1)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;
        else
            state <= next_state;
    end

    // Moore output depends only on state
    assign out = state;

endmodule