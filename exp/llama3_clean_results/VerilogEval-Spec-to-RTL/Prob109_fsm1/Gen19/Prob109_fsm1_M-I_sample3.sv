module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Utilizing one-hot encoding for states to potentially reduce switching activity
    // and improve timing, as it can simplify the combinational logic.
    logic state_B; // State B is represented by state_B being high
    logic state_A; // State A is represented by state_A being high
    logic next_state_B; // Next state B
    logic next_state_A; // Next state A

    // Combinational logic to determine the next state
    always_comb begin
        if (state_B) begin
            // If in state B and input is 1, stay in B; otherwise, go to A
            next_state_B = in;
            next_state_A = ~in;
        end else if (state_A) begin
            // If in state A and input is 1, stay in A; otherwise, go to B
            next_state_B = ~in;
            next_state_A = in;
        end else begin
            // Default to state B
            next_state_B = 1'b1;
            next_state_A = 1'b0;
        end
    end

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronously reset to state B
            state_B <= 1'b1;
            state_A <= 1'b0;
        end else begin
            state_B <= next_state_B;
            state_A <= next_state_A;
        end
    end

    // Directly assign output based on the state
    // Since we're using one-hot encoding, the output can simply be the state B
    assign out = state_B;

endmodule