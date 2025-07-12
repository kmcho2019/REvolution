module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions (B=1, A=0)
    reg state;

    // State transition logic (combinational)
    wire next_state = (state == 1'b0) ? in :  // if A, next state is in ? A : B
                     (state == 1'b1) ? in :  // if B, next state is in ? B : A
                     1'b1;                  // default to B

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // reset to B
        else
            state <= next_state;
    end

    // Output is simply the state bit (B=1, A=0)
    assign out = state;

endmodule