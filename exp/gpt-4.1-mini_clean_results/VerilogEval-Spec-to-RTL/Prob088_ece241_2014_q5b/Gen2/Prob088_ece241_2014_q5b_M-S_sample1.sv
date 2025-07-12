module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // One-hot state bits
    reg state_A, state_B;

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            state_A <= state_A & ~x;      // Stay in A if x=0, else go to B
            state_B <= state_A & x | state_B; // Enter B if from A with x=1, else stay in B
        end
    end

    // Mealy output logic
    assign z = (state_A & x) | (state_B & ~x);

endmodule