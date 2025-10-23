module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (0=A, 1=B)
    reg state;
    
    // Optimized next state logic:
    // state=1 (B): next_state = in (stay if 1, move to A if 0)
    // state=0 (A): next_state = ~in (stay if 1, move to B if 0)
    wire next_state = state ? in : ~in;

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