module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg complement_mode;  // 0=state_A, 1=state_B

    // Output is x when in state_A, ~x when in state_B
    assign z = x ^ complement_mode;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            complement_mode <= 1'b0;  // Reset to state_A
        end
        else if (~complement_mode & x) begin
            complement_mode <= 1'b1;  // Transition to state_B on first x=1
        end
        // Once in state_B, stay there forever (no else needed)
    end

endmodule