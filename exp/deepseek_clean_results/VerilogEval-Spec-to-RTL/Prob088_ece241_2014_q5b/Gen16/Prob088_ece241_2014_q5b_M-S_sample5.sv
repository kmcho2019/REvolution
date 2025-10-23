module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A;

    // Next state logic (state_A only)
    wire next_state_A = state_A & ~x;

    // Output logic - XOR implements the required behavior
    assign z = x ^ state_A;

    // State transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
        end
        else begin
            state_A <= next_state_A;
        end
    end

endmodule