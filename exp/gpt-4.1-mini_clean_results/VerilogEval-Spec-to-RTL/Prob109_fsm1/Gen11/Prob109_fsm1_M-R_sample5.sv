module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg state;       // current state: 0 = A, 1 = B
    wire next_state; // next state based on current state and input

    // Next state logic combinational assignment
    assign next_state = (state &  in) | (~state & ~in);
    // Explanation:
    // From B (1): 
    //   if in==0 -> A(0), so next_state=0
    //   if in==1 -> B(1), next_state=1
    // From A (0):
    //   if in==0 -> B(1), next_state=1
    //   if in==1 -> A(0), next_state=0

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1; // reset to B
        else
            state <= next_state;
    end

    // Output is Moore machine output based only on state
    assign out = state;

endmodule