module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg seen_one;  // Acts as state_B in one-hot (state_A is ~seen_one)

    // Next state logic: set seen_one when we see first '1' or maintain if already set
    wire next_seen_one = seen_one | x;

    // Output logic: x when in state_A (~seen_one), ~x when in state_B (seen_one)
    assign z = seen_one ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;  // Reset to state A
        end
        else begin
            seen_one <= next_seen_one;
        end
    end

endmodule