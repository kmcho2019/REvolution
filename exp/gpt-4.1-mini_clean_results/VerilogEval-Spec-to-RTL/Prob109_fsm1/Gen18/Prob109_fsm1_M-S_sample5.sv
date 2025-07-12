module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    reg state;

    // next_state logic simplified:
    // When in B (state=1), next state is in (1->B,0->A)
    // When in A (state=0), next state is ~in (1->A,0->B)
    wire next_state = state ? in : ~in;

    // Asynchronous reset sets state to B (1)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;
        else
            state <= next_state;
    end

    assign out = state;

endmodule