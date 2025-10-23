module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot encoding (though only two states)
    reg state_B, state_A;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_B <= 1'b1;
            state_A <= 1'b0;
        end else begin
            // Next state logic
            state_B <= (state_B & in) | (state_A & ~in);
            state_A <= (state_A & in) | (state_B & ~in);
        end
    end

    // Output logic (Moore: output depends only on state)
    assign out = state_B;  // B=1, A=0

endmodule