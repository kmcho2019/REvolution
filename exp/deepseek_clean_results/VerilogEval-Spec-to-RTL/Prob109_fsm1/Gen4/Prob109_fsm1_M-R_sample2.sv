module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register and next state logic
    reg state;
    wire next_state = state ? in : ~in;  // B->B when in=1, B->A when in=0, A->B when in=0, A->A when in=1

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to state B
        else
            state <= next_state;
    end

    // Output assignment
    assign out = state;

endmodule