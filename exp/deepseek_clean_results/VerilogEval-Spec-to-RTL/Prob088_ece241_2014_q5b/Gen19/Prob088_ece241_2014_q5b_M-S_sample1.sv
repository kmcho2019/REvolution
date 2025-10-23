module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A;

    // Output is XOR of state and input
    assign z = state_A ^ x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
        end else if (state_A) begin
            state_A <= ~x;    // Stay in A if x=0, move to B if x=1
        end
    end

endmodule