module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_reg;  // [next_state, current_state]

    always @(posedge clk) begin
        if (reset) begin
            state_reg <= 2'b10;  // Initialize to state B (current=0)
        end else begin
            state_reg <= {state_reg[0] ^ ~in, ~(state_reg[0] & ~in)};
            // Next state logic:
            // If current state is B (0): next = ~in
            // If current state is A (1): next = in
        end
    end

    assign out = ~state_reg[0];  // Output is complement of current state

endmodule