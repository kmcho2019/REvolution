module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (0=A, 1=B)
    reg state;
    
    // Optimized next state logic: B->B when in=1, B->A when in=0
    //                           A->B when in=0, A->A when in=1
    wire next_state = state ? in : ~in;

    // State update with async reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;
        else
            state <= next_state;
    end

    // Output is simply the state bit (Moore output)
    assign out = state;

endmodule