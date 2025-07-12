module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State register (1-hot: 0=A, 1=B)
    reg state_B;

    // Continuous assignment for state register with async reset
    always @(posedge clk or posedge areset) begin
        state_B <= areset ? 1'b0 : (state_B | (~state_B & x));
    end

    // Output logic - XOR of state and input
    assign z = state_B ^ x;

endmodule