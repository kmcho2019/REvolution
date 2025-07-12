module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (0=A, 1=B)
    reg state;
    
    // Optimal next state logic using XOR:
    // Equivalent to (state == A) ? ~in : in
    // Captures all transition conditions in one operation
    wire next_state = state ^ ~in;

    // State update with async reset to B (state=1)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;
        else
            state <= next_state;
    end

    // Output is simply the state bit (Moore output)
    assign out = state;

endmodule