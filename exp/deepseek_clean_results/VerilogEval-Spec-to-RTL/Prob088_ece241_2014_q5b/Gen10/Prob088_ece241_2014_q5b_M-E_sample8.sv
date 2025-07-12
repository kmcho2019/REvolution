module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_bit;  // 0 = A, 1 = B

    // Output is x when in A, ~x when in B
    assign z = x ^ state_bit;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_bit <= 1'b0;  // Reset to state A
        end
        else if (~state_bit & x) begin
            state_bit <= 1'b1;  // Transition A->B when x=1
        end
        // Once in B, stay in B (no else needed)
    end

endmodule