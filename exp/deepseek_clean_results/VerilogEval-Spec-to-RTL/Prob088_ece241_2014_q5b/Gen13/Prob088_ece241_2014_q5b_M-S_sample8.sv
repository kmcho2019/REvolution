module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Single state register (one-hot)
    reg state_A;

    // Next state logic (combinational)
    wire next_state_A = state_A ? ~x : 1'b0;

    // Output logic (combinational Mealy output)
    assign z = x ^ state_A;

    // State register updates (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to state A
            state_A <= 1'b1;
        end else begin
            // Normal state transition
            state_A <= next_state_A;
        end
    end

endmodule