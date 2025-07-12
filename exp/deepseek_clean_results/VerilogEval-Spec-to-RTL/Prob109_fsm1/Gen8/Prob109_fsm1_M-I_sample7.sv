module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register (1=A, 0=B)
    reg state;
    
    // Next state logic:
    // state=1 (A): next_state = in (stay if 1, move to B if 0)
    // state=0 (B): next_state = ~in (stay if 0, move to A if 1)
    wire next_state = in ^ state;

    // State update with async reset to B (state=0)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;
        else
            state <= next_state;
    end

    // Output is simply the state bit (Moore output)
    assign out = state;

endmodule