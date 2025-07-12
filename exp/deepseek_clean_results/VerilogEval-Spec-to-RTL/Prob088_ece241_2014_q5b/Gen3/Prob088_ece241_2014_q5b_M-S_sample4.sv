module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_B;

    // Next state is B if already in B, or if in A and x=1
    wire next_state_B = state_B | (~state_B & x);

    // Output depends on current state and input
    assign z = state_B ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b0;  // Reset to state A (state_B=0)
        end
        else begin
            state_B <= next_state_B;
        end
    end

endmodule