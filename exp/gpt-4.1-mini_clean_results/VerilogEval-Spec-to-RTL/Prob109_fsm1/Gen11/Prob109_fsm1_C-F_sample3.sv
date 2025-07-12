module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Combinational next-state logic with explicit case to minimize toggling
    always @(*) begin
        case (state)
            B: next_state = in ? B : A; // from B: 1->B,0->A
            A: next_state = in ? A : B; // from A: 1->A,0->B
            default: next_state = B;    // safe fallback to reset state
        endcase
    end

    // State register with asynchronous reset, non-blocking assignment for clarity
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output directly from state
    assign out = state;

endmodule